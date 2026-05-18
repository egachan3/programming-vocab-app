class CreateWords < ActiveRecord::Migration[8.1]
  def change
    create_table :words do |t|
      t.string :term, null: false
      t.text :description, null: false
      t.text :code_example
      t.integer :level, null: false
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
