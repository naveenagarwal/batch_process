class ImageData < ActiveRecord::Base
  belongs_to :batch_process

  validates :scale, :width, :height, :stagger, :coursing, :material,
      :mortar, :output, presence: true

  before_save :correct_output_extention_if_required
  before_destroy :can_destroy?

  def status_name
    STATUS.each { |k, v| return k.to_s.humanize if v == status }
  end

  def can_destroy?
    batch_process.can_destroy?
  end

  def downloadable?
    output_path.present?
  end

  private

    def correct_output_extention_if_required
      self.output = "#{output}.png" if output.present? && File.extname(output).size == 0
    end

end
