# Rails - モデルエラーに関する用語のシードデータ

category = Category.find_or_create_by!(name: 'モデルエラー', large_category: @rails_category)

words = [
  # ===== Level 1 =====
  {
    term: 'errors',
    description: 'モデルのバリデーションエラーを保持するオブジェクト。saveやvalidate!を実行した後にエラー情報が格納される。ActiveModel::Errorsのインスタンス。',
    code_example: <<~'RUBY',
      user = User.new
      user.valid?

      user.errors
      # => #<ActiveModel::Errors ...>

      user.errors.any?    # => true（エラーがある場合）
      user.errors.count   # => 2
    RUBY
    level: 1
  },
  {
    term: 'full_messages',
    description: 'バリデーションエラーのメッセージを「属性名 エラー内容」の形式の文字列配列で返すメソッド。ビューでエラー一覧を表示するときによく使う。',
    code_example: <<~'RUBY',
      user = User.new
      user.valid?
      user.errors.full_messages
      # => ["名前を入力してください", "メールアドレスを入力してください"]

      # ビューで表示する例
      # user.errors.full_messages.each do |message|
      #   puts message
      # end
    RUBY
    level: 1
  },
  {
    term: 'add',
    description: '指定した属性にカスタムエラーメッセージを追加するメソッド。カスタムバリデーションメソッド内でエラーを手動で追加するときに使う。',
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
    term: 'messages',
    description: 'エラーメッセージを属性名をキー・メッセージの配列を値とするハッシュで返すメソッド。属性ごとのエラーを取得したいときに使う。',
    code_example: <<~'RUBY',
      user = User.new
      user.valid?
      user.errors.messages
      # => { name: ["を入力してください"], email: ["を入力してください"] }

      user.errors.messages[:name]
      # => ["を入力してください"]
    RUBY
    level: 1
  },
  {
    term: 'full_messages_for',
    description: '指定した属性のエラーメッセージだけをfull_messages形式（「属性名 エラー内容」）の配列で返すメソッド。',
    code_example: <<~'RUBY',
      user = User.new
      user.valid?
      user.errors.full_messages_for(:name)
      # => ["名前を入力してください"]

      user.errors.full_messages_for(:email)
      # => ["メールアドレスを入力してください"]
    RUBY
    level: 1
  },

  # ===== Level 2 =====
  {
    term: 'each',
    description: 'エラーオブジェクトをイテレートするメソッド。各エラーはActiveModel::Errorオブジェクトで、attribute・type・messageなどにアクセスできる。',
    code_example: <<~'RUBY',
      user.errors.each do |error|
        puts error.attribute  # => :name
        puts error.type       # => :blank
        puts error.message    # => "を入力してください"
      end
    RUBY
    level: 2
  },
  {
    term: 'include?',
    description: '指定した属性にエラーが存在するか確認するメソッド。属性名をシンボルで渡す。',
    code_example: <<~'RUBY',
      user = User.new
      user.valid?

      user.errors.include?(:name)
      # => true（nameにエラーがある場合）

      user.errors.include?(:email)
      # => false（emailにエラーがない場合）
    RUBY
    level: 2
  },
  {
    term: 'added?',
    description: '指定した属性に特定のエラータイプが追加されているかを確認するメソッド。',
    code_example: <<~'RUBY',
      user = User.new
      user.valid?

      user.errors.added?(:name, :blank)
      # => true（nameに:blankエラーがある場合）

      user.errors.added?(:name, :too_long, count: 10)
      # => true（nameが長すぎるエラーがある場合）
    RUBY
    level: 2
  },
  {
    term: 'attribute_names',
    description: 'エラーが存在する属性名の一覧を配列で返すメソッド。どの属性にエラーがあるかを確認するときに使う。',
    code_example: <<~'RUBY',
      user = User.new
      user.valid?

      user.errors.attribute_names
      # => [:name, :email]
    RUBY
    level: 2
  },
  {
    term: 'messages_for',
    description: '指定した属性のエラーメッセージだけを配列で返すメソッド。full_messages_forと異なり属性名のプレフィックスが付かない。',
    code_example: <<~'RUBY',
      user = User.new
      user.valid?

      user.errors.messages_for(:name)
      # => ["を入力してください"]（属性名なし）

      # full_messages_forとの違い
      user.errors.full_messages_for(:name)
      # => ["名前を入力してください"]（属性名あり）
    RUBY
    level: 2
  },
  {
    term: 'of_kind?',
    description: '指定した属性に特定のエラータイプが存在するかを確認するメソッド。added?とほぼ同じだがメッセージの詳細オプションを必要としない点が異なる。',
    code_example: <<~'RUBY',
      user = User.new
      user.valid?

      user.errors.of_kind?(:name, :blank)
      # => true
    RUBY
    level: 2
  },

  # ===== Level 3 =====
  {
    term: 'where',
    description: '条件に合うエラーオブジェクトの配列を返すメソッド。属性・エラータイプ・オプションで絞り込める。',
    code_example: <<~'RUBY',
      user.errors.where(:name)
      # => nameに関するエラーオブジェクトの配列

      user.errors.where(:name, :too_long)
      # => nameの長さエラーのみ
    RUBY
    level: 3
  },
  {
    term: 'generate_message',
    description: 'i18nを使ってエラーメッセージを生成するメソッド。カスタムバリデーションで国際化対応したエラーメッセージを生成するときに使う。',
    code_example: <<~'RUBY',
      user.errors.generate_message(:name, :blank)
      # => "を入力してください"

      user.errors.generate_message(:name, :too_long, count: 10)
      # => "は10文字以内で入力してください"
    RUBY
    level: 3
  },
  {
    term: 'group_by_attribute',
    description: 'エラーを属性名ごとにグループ化したハッシュを返すメソッド。キーが属性名（シンボル）、値がそのエラーオブジェクトの配列になる。',
    code_example: <<~'RUBY',
      user.errors.group_by_attribute
      # => {
      #   name:  [#<ActiveModel::Error ...>],
      #   email: [#<ActiveModel::Error ...>]
      # }
    RUBY
    level: 3
  },
  {
    term: 'to_hash',
    description: 'エラーをハッシュ形式に変換するメソッド。messagesと似ているが、full_messagesオプションを渡すことで属性名付きのメッセージを取得できる。',
    code_example: <<~'RUBY',
      user.errors.to_hash
      # => { name: ["を入力してください"] }

      user.errors.to_hash(true)
      # => { name: ["名前を入力してください"] }
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
