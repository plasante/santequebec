class CreateExaminations < ActiveRecord::Migration
  def self.up
    create_table :examinations do |t|
      t.string   :study
      t.string   :name
      t.string   :voltage
      t.string   :current
      t.string   :exposure
      t.integer  :lock_version
      t.timestamps
    end
  end

  def self.down
    drop_table :examinations
  end
end
