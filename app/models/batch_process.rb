require 'csv'

class BatchProcess < ActiveRecord::Base
  mount_uploader :name, BatchProcessUploader

  validates :name, presence: true

  has_many :image_data, class_name: "ImageData", dependent: :destroy

  before_destroy :can_destroy?

  def build_image_data_from_array image_data_array
    image_data_array.each do |image_data_attributes|
      self.image_data.build image_data_attributes
    end
  end

  def create_csv filename
    path = Rails.root + "public/uploads/batch_process/#{filename}.csv"
    CSV.open(path, "wb") do |csv|
      csv << ["scale", "width", "height", "stagger", "coursing", "material", "mortar", "output" ]

      image_data.each do |data|
        csv << [data.scale, data.width, data.height, data.stagger, data.coursing, data.material, data.mortar, data.output ]
      end
    end
    path
  end

  def build_image_data_from_csv file
    CSV.foreach(file, headers: true) do |image_data_attributes|
      self.image_data.build image_data_attributes.to_hash
    end
  end

  def get_status_name value
    STATUS.each { |k, v| return k.to_s.humanize if v == value }
  end

  def can_destroy?
    pending_status?
  end

  def can_run?
    pending_status?
  end

  def refreshable?
    [STATUS[:in_progress], STATUS[:in_queue]].include? status
  end

  private

    def pending_status?
      STATUS[:pending] == status
    end

end
