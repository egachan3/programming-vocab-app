# Rails - マイグレーションに関する用語のシードデータ

category = Category.find_or_create_by!(name: 'マイグレーション', large_category: @rails_category)

words = [
  # ===== Level 1 =====
  {
    term: 'up',
    description: 'マイグレーションを適用するときに実行されるメソッド。db:migrateを実行したときに呼ばれる。changeメソッドを使わず、upとdownを明示的に定義したいときに使う。',
    code_example: <<~'RUBY',
      class AddAgeToUsers < ActiveRecord::Migration[8.0]
        def up
          add_column :users, :age, :integer
        end

        def down
          remove_column :users, :age
        end
      end
    RUBY
    level: 1
  },
  {
    term: 'down',
    description: 'マイグレーションをロールバックするときに実行されるメソッド。db:rollbackを実行したときに呼ばれる。upで行った変更を取り消す処理を書く。',
    code_example: <<~'RUBY',
      class AddAgeToUsers < ActiveRecord::Migration[8.0]
        def up
          add_column :users, :age, :integer
        end

        def down
          remove_column :users, :age
        end
      end
    RUBY
    level: 1
  },
  {
    term: 'create_table',
    description: '新しいテーブルを作成するメソッド。ブロック内でカラムを定義する。idカラムは自動で作成される。',
    code_example: <<~'RUBY',
      def change
        create_table :users do |t|
          t.string  :name,  null: false
          t.string  :email, null: false
          t.integer :age
          t.boolean :active, default: true

          t.timestamps
        end
      end
    RUBY
    level: 1
  },
  {
    term: 'add_column',
    description: '既存のテーブルに新しいカラムを追加するメソッド。テーブル名・カラム名・データ型の順に指定する。',
    code_example: <<~'RUBY',
      def change
        add_column :users, :phone, :string
        add_column :users, :age,   :integer, default: 0, null: false
        add_column :posts, :published_at, :datetime
      end
    RUBY
    level: 1
  },
  {
    term: 'remove_column',
    description: '既存のテーブルからカラムを削除するメソッド。ロールバックに対応させるためカラムの型も指定することが推奨される。',
    code_example: <<~'RUBY',
      def change
        remove_column :users, :phone, :string
        # 型を指定するとロールバック時に自動で add_column される
      end
    RUBY
    level: 1
  },
  {
    term: 'change_column',
    description: '既存のカラムの定義（型・オプション）を変更するメソッド。自動ロールバックに対応していないため、upとdownを明示的に定義することが多い。',
    code_example: <<~'RUBY',
      def up
        change_column :users, :age, :string
      end

      def down
        change_column :users, :age, :integer
      end
    RUBY
    level: 1
  },
  {
    term: 'add_index',
    description: 'テーブルにインデックスを追加するメソッド。検索・ソートが頻繁なカラムや外部キーに追加するとクエリが高速化する。',
    code_example: <<~'RUBY',
      def change
        add_index :users, :email, unique: true
        add_index :posts, :user_id
        add_index :posts, [:user_id, :created_at]
      end
    RUBY
    level: 1
  },
  {
    term: 'add_reference',
    description: '外部キーカラムとインデックスをまとめて追加するメソッド。belongs_toの関係を作るときに使う。_idカラムとインデックスが自動で作成される。',
    code_example: <<~'RUBY',
      def change
        add_reference :posts, :user, null: false, foreign_key: true
        # posts.user_id カラムとインデックスが追加される

        add_reference :comments, :post, foreign_key: true
      end
    RUBY
    level: 1
  },
  {
    term: 'add_timestamps',
    description: 'created_atとupdated_atカラムをまとめて追加するメソッド。既存テーブルにタイムスタンプを後から追加するときに使う。',
    code_example: <<~'RUBY',
      def change
        add_timestamps :users
        # created_at と updated_at が追加される

        add_timestamps :posts, null: false
      end
    RUBY
    level: 1
  },

  # ===== Level 2 =====
  {
    term: 'change_table',
    description: '既存テーブルへの複数の変更をまとめて行うメソッド。ブロック内でカラムの追加・削除・変更をまとめて記述できる。',
    code_example: <<~'RUBY',
      def change
        change_table :users do |t|
          t.string  :nickname
          t.remove  :phone
          t.rename  :name, :full_name
        end
      end
    RUBY
    level: 2
  },
  {
    term: 'rename_table',
    description: 'テーブル名を変更するメソッド。',
    code_example: <<~'RUBY',
      def change
        rename_table :members, :users
        # membersテーブルをusersに改名
      end
    RUBY
    level: 2
  },
  {
    term: 'drop_table',
    description: 'テーブルを削除するメソッド。自動ロールバックに対応させるためforceオプションやブロックでテーブル定義を渡すことが推奨される。',
    code_example: <<~'RUBY',
      def change
        drop_table :legacy_logs, if_exists: true

        # ロールバック対応のためブロックでカラム定義を渡す
        drop_table :old_users do |t|
          t.string :name
          t.timestamps
        end
      end
    RUBY
    level: 2
  },
  {
    term: 'rename_column',
    description: '既存のカラム名を変更するメソッド。',
    code_example: <<~'RUBY',
      def change
        rename_column :users, :name, :full_name
        rename_column :posts, :body, :content
      end
    RUBY
    level: 2
  },
  {
    term: 'change_column_default',
    description: 'カラムのデフォルト値を変更するメソッド。fromとtoを指定すると自動ロールバックに対応する。',
    code_example: <<~'RUBY',
      def change
        change_column_default :users, :active, from: nil, to: true
        change_column_default :posts, :status, from: "draft", to: "published"
      end
    RUBY
    level: 2
  },
  {
    term: 'change_column_null',
    description: 'カラムのNOT NULL制約を追加・削除するメソッド。falseでNOT NULL制約を追加、trueで削除する。',
    code_example: <<~'RUBY',
      def change
        change_column_null :users, :email, false
        # email カラムに NOT NULL 制約を追加

        change_column_null :users, :phone, true
        # phone カラムの NOT NULL 制約を削除
      end
    RUBY
    level: 2
  },
  {
    term: 'create_join_table',
    description: '中間テーブル（joinテーブル）を作成するメソッド。多対多の関連を実現するために使う。idカラムは作成されない。',
    code_example: <<~'RUBY',
      def change
        create_join_table :posts, :tags do |t|
          t.index :post_id
          t.index :tag_id
        end
        # posts_tags テーブルが作成される
      end
    RUBY
    level: 2
  },
  {
    term: 'reversible',
    description: 'changeメソッド内で自動ロールバックできない処理を記述するメソッド。upブロックとdownブロックをそれぞれ定義できる。',
    code_example: <<~'RUBY',
      def change
        reversible do |dir|
          dir.up   { execute "UPDATE users SET role = 'member' WHERE role IS NULL" }
          dir.down { execute "UPDATE users SET role = NULL WHERE role = 'member'" }
        end
      end
    RUBY
    level: 2
  },
  {
    term: 'execute',
    description: '生のSQLを直接実行するメソッド。Active RecordのAPIでは表現できない複雑なSQL操作が必要なときに使う。',
    code_example: <<~'RUBY',
      def change
        execute <<-SQL
          UPDATE users
          SET status = 'active'
          WHERE created_at > '2024-01-01'
        SQL
      end
    RUBY
    level: 2
  },

  # ===== Level 3 =====
  {
    term: 'revert',
    description: '別のマイグレーションの変更を取り消すメソッド。指定したマイグレーションクラスのchangeメソッドを逆方向に実行する。',
    code_example: <<~'RUBY',
      class RevertAddPhoneToUsers < ActiveRecord::Migration[8.0]
        def change
          revert AddPhoneToUsers
          # AddPhoneToUsersマイグレーションを逆に実行する
        end
      end
    RUBY
    level: 3
  },
  {
    term: 'remove_index',
    description: 'テーブルのインデックスを削除するメソッド。カラム名またはインデックス名を指定する。',
    code_example: <<~'RUBY',
      def change
        remove_index :users, :email
        remove_index :posts, column: [:user_id, :created_at]
        remove_index :users, name: "index_users_on_email"
      end
    RUBY
    level: 3
  },
  {
    term: 'table_exists?',
    description: '指定したテーブルが存在するか確認するメソッド。条件付きでテーブル操作を行うときに使う。',
    code_example: <<~'RUBY',
      def up
        if table_exists?(:old_users)
          drop_table :old_users
        end
      end
    RUBY
    level: 3
  },
  {
    term: 'column_exists?',
    description: '指定したカラムが存在するか確認するメソッド。べき等なマイグレーションを作るときに使う。',
    code_example: <<~'RUBY',
      def change
        unless column_exists?(:users, :nickname)
          add_column :users, :nickname, :string
        end
      end
    RUBY
    level: 3
  },
  {
    term: 'add_check_constraint',
    description: 'データベースレベルのチェック制約を追加するメソッド。Rails 6.1以降で使える。アプリ側のバリデーションとは別にDB側でデータの整合性を担保する。',
    code_example: <<~'RUBY',
      def change
        add_check_constraint :orders,
          "amount > 0",
          name: "orders_amount_positive"
      end
    RUBY
    level: 3
  }
]

words.each do |word_attrs|
  Word.find_or_create_by!(term: word_attrs[:term], category: category) do |word|
    word.description = word_attrs[:description]
    word.code_example = word_attrs[:code_example]
    word.level = word_attrs[:level]
  end
end
