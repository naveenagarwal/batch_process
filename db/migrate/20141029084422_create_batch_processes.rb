class CreateBatchProcesses < ActiveRecord::Migration
  def change
    create_table :batch_processes do |t|
      t.string :name
      t.integer :status, default: STATUS[:pending]
      t.integer :failed
      t.integer :completed
      t.integer :successfull

      t.timestamps
    end
  end
end
