# Rails - バリデーションに関する用語のシードデータ

category = Category.find_or_create_by!(name: 'バリデーション', large_category: @rails_category)

words = [
  # ===== Level 1 =====
  {
    term: 'validates',
    description: 'モデルの属性に対してバリデーションを設定するクラスメソッド。複数のバリデーションを1行にまとめて書けるRails推奨の書き方。',
    code_example: <<~'RUBY',
      class User < ApplicationRecord
        validates :name,  presence: true, length: { maximum: 50 }
        validates :email, presence: true, uniqueness: true,
                          format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
        validates :age,   numericality: { greater_than: 0 }, allow_nil: true
      end
    RUBY
    level: 1
  },
  {
    term: 'validate',
    description: 'カスタムバリデーションメソッドを登録するクラスメソッド。組み込みのバリデーションでは表現できない複雑なルールを自前のメソッドで定義するときに使う。',
    code_example: <<~'RUBY',
      class User < ApplicationRecord
        validate :name_must_not_include_number

        private

        def name_must_not_include_number
          if name&.match?(/\d/)
            errors.add(:name, "に数字を含めることはできません")
          end
        end
      end
    RUBY
    level: 1
  },
  {
    term: 'valid?',
    description: 'バリデーションを実行してモデルが有効かどうかをtrue/falseで返すメソッド。trueならerrors は空、falseならerrorsにエラーが格納される。',
    code_example: <<~'RUBY',
      user = User.new(name: "", email: "invalid")
      user.valid?   # => false

      user.errors.full_messages
      # => ["名前を入力してください", "メールアドレスは不正な値です"]

      user2 = User.new(name: "Alice", email: "alice@example.com")
      user2.valid?  # => true
    RUBY
    level: 1
  },
  {
    term: 'invalid?',
    description: 'バリデーションを実行してモデルが無効かどうかをtrue/falseで返すメソッド。valid?の逆。',
    code_example: <<~'RUBY',
      user = User.new(name: "")
      user.invalid?   # => true

      if user.invalid?
        puts user.errors.full_messages
      end
    RUBY
    level: 1
  },
  {
    term: 'validates_presence_of',
    description: '属性の値が空でないことを検証するクラスメソッド。validates :name, presence: true と同じ意味。Rails 2 スタイルの旧記法だが現在も動作する。',
    code_example: <<~'RUBY',
      # 旧記法（Rails 2 スタイル）
      validates_presence_of :name, :email

      # 現在の推奨記法（同じ意味）
      validates :name,  presence: true
      validates :email, presence: true
    RUBY
    level: 1
  },

  # ===== Level 2 =====
  {
    term: 'validates_uniqueness_of',
    description: '属性の値がテーブル内で一意であることを検証するクラスメソッド。validates :email, uniqueness: true と同じ意味。',
    code_example: <<~'RUBY',
      # 旧記法
      validates_uniqueness_of :email

      # 現在の推奨記法
      validates :email, uniqueness: true

      # スコープ付きで一意性を確認
      validates :name, uniqueness: { scope: :team_id }
    RUBY
    level: 2
  },
  {
    term: 'validates_length_of',
    description: '属性の文字列長を検証するクラスメソッド。validates :name, length: { ... } と同じ意味。',
    code_example: <<~'RUBY',
      # 旧記法
      validates_length_of :name, maximum: 50

      # 現在の推奨記法
      validates :name,     length: { maximum: 50 }
      validates :password, length: { minimum: 8 }
      validates :zip,      length: { is: 7 }
      validates :body,     length: { in: 10..1000 }
    RUBY
    level: 2
  },
  {
    term: 'validates_numericality_of',
    description: '属性の値が数値であることを検証するクラスメソッド。validates :age, numericality: true と同じ意味。',
    code_example: <<~'RUBY',
      # 旧記法
      validates_numericality_of :age, greater_than: 0

      # 現在の推奨記法
      validates :age,   numericality: { greater_than: 0 }
      validates :price, numericality: { greater_than_or_equal_to: 0 }
      validates :count, numericality: { only_integer: true }
    RUBY
    level: 2
  },
  {
    term: 'validates_format_of',
    description: '属性の値が正規表現にマッチするかを検証するクラスメソッド。validates :email, format: { with: /正規表現/ } と同じ意味。',
    code_example: <<~'RUBY',
      # 旧記法
      validates_format_of :email, with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

      # 現在の推奨記法
      validates :email,    format: { with: URI::MailTo::EMAIL_REGEXP }
      validates :zip_code, format: { with: /\A\d{3}-\d{4}\z/ }
    RUBY
    level: 2
  },
  {
    term: 'validates_inclusion_of',
    description: '属性の値が指定した配列やレンジに含まれるかを検証するクラスメソッド。validates :status, inclusion: { in: [...] } と同じ意味。',
    code_example: <<~'RUBY',
      # 旧記法
      validates_inclusion_of :status, in: %w[draft published archived]

      # 現在の推奨記法
      validates :status, inclusion: { in: %w[draft published archived] }
      validates :level,  inclusion: { in: 1..5 }
    RUBY
    level: 2
  },
  {
    term: 'validates_confirmation_of',
    description: 'パスワードなど確認入力が元の値と一致するかを検証するクラスメソッド。_confirmationサフィックスのフィールドと比較する。',
    code_example: <<~'RUBY',
      # 旧記法
      validates_confirmation_of :password

      # 現在の推奨記法
      validates :password, confirmation: true

      # フォーム側では password_confirmation フィールドが必要
      # <%= f.password_field :password_confirmation %>
    RUBY
    level: 2
  },

  # ===== Level 3 =====
  {
    term: 'validates_associated',
    description: '関連するモデルのバリデーションも実行するクラスメソッド。保存時に関連モデルが無効な場合に親モデルのバリデーションも失敗させる。',
    code_example: <<~'RUBY',
      class User < ApplicationRecord
        has_many :posts
        validates_associated :posts
        # User の保存時に Post のバリデーションも実行される
      end
    RUBY
    level: 3
  },
  {
    term: 'validates_with',
    description: '専用のバリデータークラスを使ってバリデーションを行うクラスメソッド。複雑なバリデーションロジックを別クラスに切り出したいときに使う。',
    code_example: <<~'RUBY',
      class UserValidator < ActiveModel::Validator
        def validate(record)
          if record.name.start_with?("X")
            record.errors.add(:name, "はXで始められません")
          end
        end
      end

      class User < ApplicationRecord
        validates_with UserValidator
      end
    RUBY
    level: 3
  },
  {
    term: 'validates_each',
    description: '指定した各属性に対してブロックでカスタムバリデーションを実行するクラスメソッド。validate（インスタンスメソッド）より簡潔に複数属性を検証できる。',
    code_example: <<~'RUBY',
      class User < ApplicationRecord
        validates_each :name, :email do |record, attr, value|
          if value&.start_with?("admin")
            record.errors.add(attr, "をadminで始めることはできません")
          end
        end
      end
    RUBY
    level: 3
  },
  {
    term: 'validates!',
    description: 'バリデーションが失敗したときにActiveModel::StrictValidationFailedを発生させる厳格なバリデーションを設定するクラスメソッド。必ず成功すべき前提条件のチェックに使う。',
    code_example: <<~'RUBY',
      class User < ApplicationRecord
        validates! :email, presence: true
        # email が空の場合は例外が発生する
      end

      # validates に strict: true を渡しても同じ
      validates :email, presence: { strict: true }
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
