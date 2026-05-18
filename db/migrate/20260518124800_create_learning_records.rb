class CreateLearningRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :learning_records do |t|
      t.references :user, null: false, foreign_key: true
      t.references :word, null: false, foreign_key: true
      t.boolean :remembered, null: false, default: false

      t.timestamps
    end
  end
end
