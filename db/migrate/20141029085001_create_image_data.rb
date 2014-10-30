class CreateImageData < ActiveRecord::Migration
  def change
    create_table :image_data do |t|
      t.integer :scale
      t.integer :width
      t.integer :height
      t.integer :mortar
      t.integer :material
      t.string :output
      t.references :batch_process, index: true
      t.integer :stagger
      t.integer :coursing
      t.integer :coursing
      t.integer :status, default: STATUS[:pending]
      t.string :output_path
      t.string :message
      t.text :backtrace

      t.timestamps
    end
  end
end
