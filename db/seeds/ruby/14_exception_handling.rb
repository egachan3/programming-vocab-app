# Ruby - 例外処理に関する用語のシードデータ

category = Category.find_or_create_by!(name: '例外処理', large_category: @ruby_category)

words = [
  {
    term: 'begin/rescue',
    description: '例外を補足して処理するための構文。`begin` ブロック内で発生した例外を `rescue` で受け取り、代替処理を行う。',
    code_example: <<~'RUBY',
      begin
        result = 10 / 0
      rescue ZeroDivisionError => e
        puts "エラー: #{e.message}"  # => エラー: divided by 0
      end
    RUBY
    level: 2
  },
  {
    term: 'ensure',
    description: '例外の発生有無にかかわらず必ず実行されるブロック。ファイルのクローズやリソースの解放などに使う。',
    code_example: <<~'RUBY',
      begin
        puts "処理中"
        raise "エラー発生"
      rescue => e
        puts "補足: #{e.message}"
      ensure
        puts "必ず実行される"
      end
      # => 処理中
      #    補足: エラー発生
      #    必ず実行される
    RUBY
    level: 2
  },
  {
    term: 'raise',
    description: '意図的に例外を発生させるメソッド。例外クラスとメッセージを指定できる。',
    code_example: <<~'RUBY',
      def check_age(age)
        raise ArgumentError, "年齢は0以上にしてください" if age < 0
        puts "年齢: #{age}"
      end

      begin
        check_age(-1)
      rescue ArgumentError => e
        puts e.message  # => 年齢は0以上にしてください
      end
    RUBY
    level: 2
  },
  {
    term: 'retry',
    description: '`rescue` 内で使い、`begin` からの処理を再実行する。リトライ回数の制限を設けないと無限ループになるので注意。',
    code_example: <<~'RUBY',
      attempts = 0

      begin
        attempts += 1
        raise "失敗" if attempts < 3
        puts "成功（#{attempts}回目）"
      rescue
        retry if attempts < 3
        puts "リトライ上限に達しました"
      end
      # => 成功（3回目）
    RUBY
    level: 3
  },
  {
    term: 'Exception',
    description: 'Rubyのすべての例外クラスの最上位クラス。`rescue Exception` とすると `Interrupt` や `SystemExit` なども補足してしまうため、通常は `StandardError` を使う。',
    code_example: <<~'RUBY',
      # Exception は捕捉しすぎるため原則使わない
      begin
        raise "テスト"
      rescue Exception => e
        puts e.class    # => RuntimeError
        puts e.message  # => テスト
      end
    RUBY
    level: 2
  },
  {
    term: 'StandardError',
    description: '通常のプログラムエラーの基底クラス。`rescue` で例外クラスを省略した場合はこのクラスとそのサブクラスを補足する。',
    code_example: <<~'RUBY',
      begin
        Integer("abc")
      rescue StandardError => e
        puts e.class    # => ArgumentError
        puts e.message  # => invalid value for Integer(): "abc"
      end
    RUBY
    level: 2
  },
  {
    term: 'RuntimeError',
    description: '`raise "メッセージ"` のように例外クラスを指定せずに raise した場合に発生するデフォルトの例外クラス。`StandardError` のサブクラス。',
    code_example: <<~'RUBY',
      begin
        raise "何か問題が起きました"
      rescue RuntimeError => e
        puts e.class    # => RuntimeError
        puts e.message  # => 何か問題が起きました
      end
    RUBY
    level: 2
  },
  {
    term: 'カスタム例外',
    description: '`StandardError`（または他の例外クラス）を継承して独自の例外クラスを作ること。アプリケーション固有のエラーを表現できる。',
    code_example: <<~'RUBY',
      class InsufficientFundsError < StandardError
        def initialize(amount)
          super("残高不足: #{amount}円不足しています")
        end
      end

      begin
        raise InsufficientFundsError.new(500)
      rescue InsufficientFundsError => e
        puts e.message  # => 残高不足: 500円不足しています
      end
    RUBY
    level: 3
  },
  {
    term: '例外メッセージ',
    description: '例外オブジェクトの `message` メソッドでエラーの詳細を取得できる。`backtrace` でスタックトレースも参照できる。',
    code_example: <<~'RUBY',
      begin
        raise ArgumentError, "不正な引数です"
      rescue => e
        puts e.class    # => ArgumentError
        puts e.message  # => 不正な引数です
        # puts e.backtrace.first  # エラー発生箇所のファイル・行番号
      end
    RUBY
    level: 2
  }
]

words.each do |word_attrs|
  Word.find_or_create_by!(term: word_attrs[:term], category: category) do |word|
    word.description = word_attrs[:description]
    word.code_example = word_attrs[:code_example]
    word.level = word_attrs[:level]
  end
end
