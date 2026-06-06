# Rails - パラメーターに関する用語のシードデータ

category = Category.find_or_create_by!(name: 'パラメーター', large_category: @rails_category)

words = [
  # ===== Level 1 =====
  {
    term: 'require',
    description: 'Strong Parametersで特定のキーが必須であることを宣言するメソッド。指定したキーが存在しない場合はActionController::ParameterMissingを発生させる。permitと組み合わせてセキュアにパラメーターを取得する。',
    code_example: <<~'RUBY',
      def user_params
        params.require(:user).permit(:name, :email)
      end

      # params = { user: { name: "Alice", email: "alice@example.com" } }
      # user_params => { name: "Alice", email: "alice@example.com" }
    RUBY
    level: 1
  },
  {
    term: 'permit',
    description: 'Strong Parametersで許可するパラメーターのキーを指定するメソッド。指定したキーのみを通過させ、それ以外のキーは除外する。セキュリティのため必ずrequireと組み合わせて使う。',
    code_example: <<~'RUBY',
      params.require(:user).permit(:name, :email, :age)

      # ネストしたパラメーターを許可する場合
      params.require(:user).permit(:name, address: [:city, :zip])

      # 配列を許可する場合
      params.require(:post).permit(tag_ids: [])
    RUBY
    level: 1
  },
  {
    term: 'fetch',
    description: '指定したキーの値を取得するメソッド。キーが存在しない場合はデフォルト値を返すか、ブロックを実行する。キーが必須のときにデフォルト値を設定したい場合に使う。',
    code_example: <<~'RUBY',
      params.fetch(:page, 1)
      # => キー :page がなければ 1 を返す

      params.fetch(:sort) { "created_at" }
      # => キー :sort がなければ "created_at" を返す
    RUBY
    level: 1
  },
  {
    term: 'slice',
    description: '指定したキーのみを含む新しいパラメーターオブジェクトを返すメソッド。必要なキーだけを抽出したいときに使う。',
    code_example: <<~'RUBY',
      params.slice(:page, :per_page)
      # => { page: "1", per_page: "20" }

      params.slice(:q, :category_id)
    RUBY
    level: 1
  },

  # ===== Level 2 =====
  {
    term: 'permit!',
    description: 'すべてのパラメーターを許可するメソッド。Strong Parametersのチェックをスキップする。セキュリティリスクがあるため、テスト環境や信頼できる内部処理以外では使わない。',
    code_example: <<~'RUBY',
      # 全パラメーターを許可（本番環境では非推奨）
      params.permit!

      # 特定のキー配下を全許可する場合
      params.require(:user).permit!
    RUBY
    level: 2
  },
  {
    term: 'dig',
    description: 'ネストされたパラメーターをキーをたどって取得するメソッド。途中のキーが存在しない場合はnilを返す。深いネストのパラメーターにアクセスするときに便利。',
    code_example: <<~'RUBY',
      # params = { user: { address: { city: "Tokyo" } } }
      params.dig(:user, :address, :city)
      # => "Tokyo"

      params.dig(:user, :phone, :number)
      # => nil（:phone が存在しなくてもエラーにならない）
    RUBY
    level: 2
  },
  {
    term: 'except',
    description: '指定したキーを除いた新しいパラメーターオブジェクトを返すメソッド。sliceの逆で、不要なキーを除外したいときに使う。',
    code_example: <<~'RUBY',
      params.except(:authenticity_token, :commit)
      # 指定したキー以外のパラメーターを返す
    RUBY
    level: 2
  },
  {
    term: 'to_h',
    description: 'パラメーターオブジェクトを通常のRubyのHashに変換するメソッド。許可されていないパラメーターが含まれている場合はエラーになる。安全な変換が必要なときはpermitを通してから使う。',
    code_example: <<~'RUBY',
      params.permit(:name, :email).to_h
      # => { "name" => "Alice", "email" => "alice@example.com" }

      # シンボルキーのHashにする場合
      params.permit(:name).to_h.symbolize_keys
      # => { name: "Alice" }
    RUBY
    level: 2
  },
  {
    term: 'permitted?',
    description: 'パラメーターが許可済み（permitを通過済み）かどうかを確認するメソッド。trueであればto_hやto_unsafe_hなしで変換できる。',
    code_example: <<~'RUBY',
      raw_params = params.require(:user)
      raw_params.permitted?    # => false

      safe_params = params.require(:user).permit(:name)
      safe_params.permitted?   # => true
    RUBY
    level: 2
  },

  # ===== Level 3 =====
  {
    term: 'to_unsafe_h',
    description: 'パラメーターオブジェクトをすべてのキーを含むHashに変換するメソッド。permitのチェックをスキップするためセキュリティリスクがある。外部からのリクエストパラメーターには使わない。',
    code_example: <<~'RUBY',
      params.to_unsafe_h
      # => { "controller" => "users", "action" => "create",
      #      "user" => { "name" => "Alice" }, ... }

      # 内部処理など信頼できるデータにのみ使用する
    RUBY
    level: 3
  },
  {
    term: 'extract!',
    description: '指定したキーをパラメーターオブジェクトから取り出して返し、元のオブジェクトからは削除するメソッド。',
    code_example: <<~'RUBY',
      params = ActionController::Parameters.new(
        name: "Alice", role: "admin", email: "alice@example.com"
      )
      extracted = params.extract!(:role)
      # extracted => { role: "admin" }
      # params    => { name: "Alice", email: "alice@example.com" }
    RUBY
    level: 3
  },
  {
    term: 'transform_values',
    description: 'パラメーターの値をブロックで変換した新しいパラメーターオブジェクトを返すメソッド。値の一括変換に使う。',
    code_example: <<~'RUBY',
      params.transform_values(&:strip)
      # 全パラメーターの値の前後の空白を除去

      params.transform_values { |v| v.is_a?(String) ? v.downcase : v }
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
