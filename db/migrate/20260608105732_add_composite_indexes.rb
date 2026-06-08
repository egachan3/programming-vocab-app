class AddCompositeIndexes < ActiveRecord::Migration[8.1]
  def change
    add_index :words, [:category_id, :level]
    add_index :learning_records, [:user_id, :word_id]
  end
end
