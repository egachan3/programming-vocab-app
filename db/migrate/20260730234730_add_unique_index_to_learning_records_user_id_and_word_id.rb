class AddUniqueIndexToLearningRecordsUserIdAndWordId < ActiveRecord::Migration[8.1]
  def up
    # 同一user_id/word_idの重複行がある場合、最新(idが大きい方)以外を削除してからユニーク制約を張る
    execute <<~SQL
      DELETE FROM learning_records a
      USING learning_records b
      WHERE a.id < b.id
        AND a.user_id = b.user_id
        AND a.word_id = b.word_id
    SQL

    remove_index :learning_records, [ :user_id, :word_id ], name: "index_learning_records_on_user_id_and_word_id"
    add_index :learning_records, [ :user_id, :word_id ], unique: true
  end

  def down
    remove_index :learning_records, [ :user_id, :word_id ]
    add_index :learning_records, [ :user_id, :word_id ], name: "index_learning_records_on_user_id_and_word_id"
  end
end
