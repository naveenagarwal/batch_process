require 'timeout'
require 'csv'
# require 'sidekiq'

BATCH_DESIGN_URL          = ENV["BATCH_DESIGN_URL"]
PHANTOM_JS_PATH           = ENV["PHANTOM_JS_PATH"]
PHANTOM_JS_RASTERIZE_PATH = ENV["PHANTOM_JS_RASTERIZE_PATH"]

class BatchServer
  include Sidekiq::Worker
  sidekiq_options :retry => false

  attr_accessor :batch_file_path, :batch_output_file_path, :rows, :json_data, :batch_process, :image_data

  def perform(batch_process_id)
    @batch_process = BatchProcess.find batch_process_id
    @image_data = @batch_process.image_data
    @batch_process.update_attribute(:status, STATUS[:in_progress])
    @batch_file_path = @batch_process.name.file.file

    log "\n\n\nStarting Batch at - #{Time.now} for the batch_process id #{batch_process.id} and name #{batch_process.name}"

    parse
    update_batch_process_status
  end

  private

  def update_batch_process_status
    image_data_count = image_data.count

    if @failed == image_data_count && image_data_count > 0
      status = STATUS[:error]
    elsif @failed > 0 && @successfull > 0
      status = STATUS[:partially_complete]
    elsif @successfull == image_data_count
      status = STATUS[:complete]
    end

    @batch_process.update_attributes(
        status: status,
        failed: @failed,
        completed: @completed,
        successfull: @successfull
      )
  end

  def parse
    reset_attributes
    to_json
    dump_batch_output
  end

  def reset_attributes
    @json_data = []
    @counter = 0
    @status = nil
    @backtrace = nil
    @message = nil
    @completed = 0
    @failed = 0
    @successfull = 0
  end

  def to_json
    image_data.each do |row|
      @json_data << {
        id:         row.id,
        scale:      row.scale,
        dimensionX: row.width,
        dimensionY: row.height,
        brick_id:   row.material,
        mortar_id:  row.mortar,
        stagger:    row.stagger,
        coursing:   row.coursing,
        output:     row.output || default_file_name
      }
    end
  end

  def default_file_name
    @counter += 1
    "#{File.basename(batch_process.name, ".*")}_#{@counter}.png"
  end

  def dump_batch_output
    @output_directory_path = "#{File.dirname(batch_file_path)}"

    @json_data.each do |data|
      if update_image_data_status(data[:id], STATUS[:in_progress])
        process_row_with data
        update_image_data_status_with_message data[:id]
      end
    end

    @current_row = nil
  end

  def update_image_data_status_with_message id
    record = image_data.find(id)
    record.update_attributes(
        status: @status,
        message: @message,
        backtrace: @backtrace
      )
  end
  def update_image_data_status id, status
    image_data.find(id).update_attribute(:status, status)
  end

  def process_row_with data
    @commands             = []
    @current_row          = data
    design_url            = "#{BATCH_DESIGN_URL}?#{query_string_from_current_row}"
    output                = "#{@output_directory_path}/#{File.basename(data[:output], '.*')}.png"
    @output_format         = "#{@output_directory_path}/#{data[:output]}"
    command               = "#{PHANTOM_JS_PATH} #{PHANTOM_JS_RASTERIZE_PATH} '#{design_url}' #{output}"

    capture_image command
    trim_image output
    change_format output, @output_format if File.extname(output) != File.extname(data[:output]).downcase
    scale_image @output_format, data[:scale] if data[:scale] != 100 && data[:scale] != 0
    run_commands
  end

  def change_format input, output
    @commands << "convert #{input} #{output}"
  end

  def capture_image command
    @commands << "#{command}"
  end

  def trim_image output
    @commands << "convert #{output} -trim +repage #{output}"
  end

  def scale_image output, scale
    @commands << "convert #{output} -resize #{scale}% #{output}"
  end

  def query_string_from_current_row
    [:dimensionX, :dimensionY, :brick_id, :mortar_id, :stagger, :coursing].map do |key|
      "#{key}=#{@current_row[key]}"
    end.join("&")
  end

  def run_commands
    command = @commands.join " && "
    log "Running command #{command} for image_data id #{@current_row[:id]}"
    @status = STATUS[:ran_successfully]
    @message = ""
    @backtrace = ""

    begin
      Timeout.timeout(1800) do
        update_image_data_status(@current_row[:id], STATUS[:running])
        system command
        @successfull += 1
        update_image_data_output_path @current_row[:id]
      end
    rescue Exception => e
      log "Could not finish the command #{command} in 1800(30 minutes or half and hour) seconds so killing it."
      @failed += 1
      @status = STATUS[:error]
      @message = e.message
      @backtrace = e.backtrace
      Process.kill("TERM", $?.pid) unless $?.nil?
      `killall -9 phantomjs`
    end
    @completed += 1
  end

  def update_image_data_output_path id
    image_data.find(id).update_attribute(:output_path, "#{File.dirname(@batch_process.name.to_s)}/#{@current_row[:output]}")
  end

  def log msg
    Sidekiq.logger.info msg
  end

end
