# Rails - アクティブサポートに関する用語のシードデータ

category = Category.find_or_create_by!(name: 'アクティブサポート', large_category: @rails_category)

words = [
  # ===== Level 1 =====
  {
    term: 'pluralize',
    description: '英単語を複数形に変換するメソッド。Railsの命名規則（モデル名→テーブル名など）に内部で使われている。Active Support の Inflector が提供する。',
    code_example: <<~'RUBY',
      "user".pluralize      # => "users"
      "category".pluralize  # => "categories"
      "person".pluralize    # => "people"
      "sheep".pluralize     # => "sheep"

      # 数値と組み合わせる
      "item".pluralize(1)   # => "item"
      "item".pluralize(2)   # => "items"
    RUBY
    level: 1
  },
  {
    term: 'singularize',
    description: '英単語の複数形を単数形に変換するメソッド。pluralizeの逆。',
    code_example: <<~'RUBY',
      "users".singularize      # => "user"
      "categories".singularize # => "category"
      "people".singularize     # => "person"
    RUBY
    level: 1
  },
  {
    term: 'underscore',
    description: 'CamelCase（UpperCamelCaseやlowerCamelCase）の文字列をsnake_caseに変換するメソッド。クラス名をファイル名やカラム名に変換するときに使われる。',
    code_example: <<~'RUBY',
      "UserProfile".underscore    # => "user_profile"
      "HTMLParser".underscore     # => "html_parser"
      "Admin::UserController".underscore  # => "admin/user_controller"
    RUBY
    level: 1
  },
  {
    term: 'camelize',
    description: 'snake_caseの文字列をCamelCaseに変換するメソッド。underscoreの逆。デフォルトはUpperCamelCase（PascalCase）で、:lowerを渡すとlowerCamelCaseになる。',
    code_example: <<~'RUBY',
      "user_profile".camelize         # => "UserProfile"
      "user_profile".camelize(:lower) # => "userProfile"
      "admin/user".camelize           # => "Admin::User"
    RUBY
    level: 1
  },
  {
    term: 'humanize',
    description: 'snake_caseの文字列を人が読みやすい形式に変換するメソッド。先頭を大文字にしアンダースコアをスペースに変換する。_idサフィックスは除去される。',
    code_example: <<~'RUBY',
      "user_name".humanize    # => "User name"
      "author_id".humanize    # => "Author"
      "ssl_error".humanize    # => "Ssl error"
    RUBY
    level: 1
  },
  {
    term: 'number_to_currency',
    description: '数値を通貨形式の文字列に変換するヘルパーメソッド。単位・区切り文字・小数点以下の桁数を指定できる。',
    code_example: <<~'RUBY',
      number_to_currency(1234567.89)
      # => "$1,234,567.89"

      number_to_currency(1234567, unit: "¥", precision: 0)
      # => "¥1,234,567"

      number_to_currency(1234.5, locale: :ja)
      # => "¥1,235"
    RUBY
    level: 1
  },
  {
    term: 'try',
    description: 'オブジェクトがnilの場合にNoMethodErrorを発生させずにnilを返すメソッド。&.（ぼっち演算子）と同じ用途だが、動的なメソッド名指定もできる。',
    code_example: <<~'RUBY',
      user = nil
      user.try(:name)    # => nil（NoMethodErrorにならない）
      user&.name         # => nil（同じ効果）

      user = User.find(1)
      user.try(:name)    # => "Alice"

      # 動的なメソッド呼び出し
      method_name = :email
      user.try(method_name)  # => "alice@example.com"
    RUBY
    level: 1
  },

  # ===== Level 2 =====
  {
    term: 'tableize',
    description: 'クラス名やモジュール名をテーブル名の形式（小文字のsnake_case複数形）に変換するメソッド。underscoreとpluralizeを組み合わせた動作をする。',
    code_example: <<~'RUBY',
      "User".tableize          # => "users"
      "LargeCategory".tableize # => "large_categories"
      "Admin::User".tableize   # => "admin_users"
    RUBY
    level: 2
  },
  {
    term: 'classify',
    description: 'テーブル名をクラス名に変換するメソッド。tableizeの逆。単数形にしてCamelCaseにする。',
    code_example: <<~'RUBY',
      "users".classify          # => "User"
      "large_categories".classify # => "LargeCategory"
      "admin_users".classify    # => "AdminUser"
    RUBY
    level: 2
  },
  {
    term: 'constantize',
    description: '文字列をRubyの定数（クラスやモジュール）に変換するメソッド。定数が存在しない場合はNameErrorを発生させる。動的なクラス呼び出しに使う。',
    code_example: <<~'RUBY',
      "User".constantize           # => User（クラスオブジェクト）
      "Admin::User".constantize    # => Admin::User

      # 動的にモデルを取得する例
      model_name = "Article"
      model_name.constantize.find(1)
      # => Article.find(1) と同じ
    RUBY
    level: 2
  },
  {
    term: 'number_with_delimiter',
    description: '数値に桁区切り文字を追加して文字列に変換するヘルパーメソッド。デフォルトはカンマ区切り。',
    code_example: <<~'RUBY',
      number_with_delimiter(1234567)
      # => "1,234,567"

      number_with_delimiter(1234567.89, delimiter: ".")
      # => "1.234.567.89"
    RUBY
    level: 2
  },
  {
    term: 'number_with_precision',
    description: '数値を指定した小数点以下の桁数で丸めて文字列に変換するヘルパーメソッド。',
    code_example: <<~'RUBY',
      number_with_precision(3.14159, precision: 2)
      # => "3.14"

      number_with_precision(1234.5678, precision: 2, delimiter: ",")
      # => "1,234.57"
    RUBY
    level: 2
  },
  {
    term: 'number_to_human_size',
    description: 'バイト数を人間が読みやすいファイルサイズ表記（KB・MB・GBなど）に変換するヘルパーメソッド。',
    code_example: <<~'RUBY',
      number_to_human_size(1024)
      # => "1 KB"

      number_to_human_size(1234567)
      # => "1.18 MB"

      number_to_human_size(1073741824)
      # => "1 GB"
    RUBY
    level: 2
  },
  {
    term: 'rescue_from',
    description: 'コントローラーで特定の例外をキャッチして処理するクラスメソッド。例外の種類ごとにエラー画面を出し分けるときに使う。',
    code_example: <<~'RUBY',
      class ApplicationController < ActionController::Base
        rescue_from ActiveRecord::RecordNotFound, with: :not_found
        rescue_from ActionController::ParameterMissing, with: :bad_request

        private

        def not_found
          render file: "public/404.html", status: :not_found
        end

        def bad_request
          render file: "public/400.html", status: :bad_request
        end
      end
    RUBY
    level: 2
  },

  # ===== Level 3 =====
  {
    term: 'html_escape',
    description: 'HTMLの特殊文字（<・>・&・"など）をエンティティに変換してXSS攻撃を防ぐメソッド。hとも書ける。Railsのビューでは文字列は自動でエスケープされるが、明示的に使う場合もある。',
    code_example: <<~'RUBY',
      html_escape("<script>alert('XSS')</script>")
      # => "&lt;script&gt;alert(&#39;XSS&#39;)&lt;/script&gt;"

      # h は html_escape の省略形
      h("<b>Bold</b>")
      # => "&lt;b&gt;Bold&lt;/b&gt;"
    RUBY
    level: 3
  },
  {
    term: 'demodulize',
    description: 'モジュール名を含む定数名からモジュールプレフィックスを取り除いて最後の部分だけを返すメソッド。',
    code_example: <<~'RUBY',
      "Admin::User".demodulize    # => "User"
      "Admin::Auth::Token".demodulize  # => "Token"
      "User".demodulize           # => "User"
    RUBY
    level: 3
  },
  {
    term: 'uuid_v4',
    description: 'ランダムなUUID（バージョン4）を生成するメソッド。SecureRandom.uuidと同様。一意なIDが必要なときに使う。',
    code_example: <<~'RUBY',
      SecureRandom.uuid
      # => "550e8400-e29b-41d4-a716-446655440000"

      # Active Support での利用
      require "active_support/core_ext/securerandom"
      SecureRandom.uuid_v4
      # => "f47ac10b-58cc-4372-a567-0e02b2c3d479"
    RUBY
    level: 3
  },
  {
    term: 'number_to_percentage',
    description: '数値をパーセント表示の文字列に変換するヘルパーメソッド。小数点以下の桁数を指定できる。',
    code_example: <<~'RUBY',
      number_to_percentage(75)
      # => "75.000%"

      number_to_percentage(75.5, precision: 1)
      # => "75.5%"

      number_to_percentage(0.235, precision: 2)
      # => "0.24%"
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
