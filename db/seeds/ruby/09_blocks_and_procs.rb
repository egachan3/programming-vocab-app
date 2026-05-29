# Ruby - ブロックとProcオブジェクトに関する用語のシードデータ

category = Category.find_or_create_by!(name: 'ブロックとProcオブジェクト', large_category: @ruby_category)

words = [
  {
    term: 'ブロック',
    description: 'メソッド呼び出し時に `do...end` または `{}` で渡す処理のまとまり。メソッドに一時的な処理を渡すことができる。',
    code_example: <<~'RUBY',
      [1, 2, 3].each do |n|
        puts n * 2
      end

      # {} を使う書き方（1行のとき）
      [1, 2, 3].each { |n| puts n * 2 }
    RUBY
    level: 1
  },
  {
    term: 'yield',
    description: 'メソッド定義内で使い、渡されたブロックを呼び出すキーワード。引数を渡すこともできる。',
    code_example: <<~'RUBY',
      def with_greeting
        puts "Before"
        yield  # 渡されたブロックを実行
        puts "After"
      end

      with_greeting { puts "Hello!" }
      # => Before
      #    Hello!
      #    After
    RUBY
    level: 3
  },
  {
    term: 'block_given?',
    description: 'メソッドにブロックが渡されているかどうかを確認するメソッド。`yield` と組み合わせてブロックの有無を条件分岐できる。',
    code_example: <<~'RUBY',
      def greet(name)
        if block_given?
          yield name
        else
          puts "Hello, #{name}!"
        end
      end

      greet("Alice")                    # => Hello, Alice!
      greet("Bob") { |n| puts "Hi, #{n}!" }  # => Hi, Bob!
    RUBY
    level: 3
  },
  {
    term: 'Proc',
    description: 'ブロックをオブジェクトとして保存したもの。`Proc.new` または `proc {}` で作成する。変数に代入して再利用できる。',
    code_example: <<~'RUBY',
      double = Proc.new { |n| n * 2 }

      puts double.call(5)   # => 10
      puts double.call(10)  # => 20

      [1, 2, 3].map(&double).inspect
      # => [2, 4, 6]
    RUBY
    level: 3
  },
  {
    term: 'lambda',
    description: 'Procと似ているが、引数チェックが厳密で `return` の挙動が異なる。`lambda {}` または `->() {}` で作成する。',
    code_example: <<~'RUBY',
      add = lambda { |a, b| a + b }
      puts add.call(3, 4)  # => 7

      # アロー構文
      multiply = ->(a, b) { a * b }
      puts multiply.call(3, 4)  # => 12
    RUBY
    level: 3
  },
  {
    term: '&演算子',
    description: 'Procオブジェクトをブロックとして渡す演算子。メソッドの最後の引数に `&` を付けるとブロックをProcとして受け取ることもできる。',
    code_example: <<~'RUBY',
      double = ->(n) { n * 2 }

      puts [1, 2, 3].map(&double).inspect
      # => [2, 4, 6]

      # メソッドをブロックとして渡す
      puts [1, -2, 3].select(&:positive?).inspect
      # => [1, 3]
    RUBY
    level: 3
  },
  {
    term: 'クロージャ',
    description: 'ブロックやProcが定義された時点の変数（ローカル変数）を保持し続ける性質。定義した場所のスコープを「閉じ込める」ことからクロージャと呼ぶ。',
    code_example: <<~'RUBY',
      def make_counter
        count = 0
        increment = -> { count += 1; count }
        increment
      end

      counter = make_counter
      puts counter.call  # => 1
      puts counter.call  # => 2
      puts counter.call  # => 3
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
