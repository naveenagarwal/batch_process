class BatchProcessesController < ApplicationController
  before_action :set_batch_process, only: [:show, :edit, :update, :destroy, :remove_image_data, :run, :refresh]

  def index
    @batch_processes = BatchProcess.includes(:image_data).order("id desc").paginate(
        page: params[:page] || DEFAULT_PAGE,
        per_page: params[:per_page] || DEFAULT_PER_PAGE
      )
  end

  def new
    @batch_process = BatchProcess.new
  end

  def create
    path = nil
    @batch_process = BatchProcess.new

    if params[:manual_entry]
      @batch_process.build_image_data_from_array batch_process_params[:image_data]
      path = @batch_process.create_csv(batch_process_params[:name])
      @batch_process.name = File.open path
    else
      @batch_process.name = batch_process_params[:name]
      @batch_process.build_image_data_from_csv params[:batch_process][:name].tempfile
    end

    respond_to do |format|
      if @batch_process.save
        File.unlink(path) if path
        format.html { redirect_to batch_processes_path, notice: 'Batch process was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @batch_process.destroy
    respond_to do |format|
      format.html { redirect_to batch_processes_path, notice: 'Batch process was successfully destroyed.' }
    end
  end

  def remove_image_data
    @image_data = @batch_process.image_data.find params[:image_data_id]
    @image_data.destroy
  end

  def run
    if @batch_process.update_attribute(:status, STATUS[:in_queue])
      BatchServer.perform_async @batch_process.id
    end
  end

  def refresh
    @image_data = @batch_process.image_data
  end

  private
    def set_batch_process
      @batch_process = BatchProcess.find(params[:id])
    end

    def batch_process_params
      params.require(:batch_process).permit(:name, image_data: [:scale, :width, :height, :stagger, :coursing, :material, :mortar, :output ])
    end
end
