# Ruby - 変数と定数に関する用語のシードデータ

category = Category.find_or_create_by!(name: '変数と定数', large_category: @ruby_category)

words = [
  {
    term: 'ローカル変数',
    description: '小文字またはアンダースコアで始まる変数。定義されたスコープ内でのみ有効。',
    code_example: <<~'RUBY',
      name = "Alice"
      _count = 0
      puts name  # => Alice
    RUBY
    level: 1
  },
  {
    term: 'インスタンス変数',
    description: '`@` で始まる変数。クラスのインスタンス（オブジェクト）ごとに保持される。',
    code_example: <<~'RUBY',
      class Person
        def initialize(name)
          @name = name
        end

        def greet
          puts "Hello, #{@name}!"
        end
      end

      p = Person.new("Alice")
      p.greet  # => Hello, Alice!
    RUBY
    level: 1
  },
  {
    term: 'クラス変数',
    description: '`@@` で始まる変数。クラスとそのすべてのインスタンスで共有される。',
    code_example: <<~'RUBY',
      class Counter
        @@count = 0

        def initialize
          @@count += 1
        end

        def self.count
          @@count
        end
      end

      Counter.new
      Counter.new
      puts Counter.count  # => 2
    RUBY
    level: 2
  },
  {
    term: 'グローバル変数',
    description: '`$` で始まる変数。プログラム全体のどこからでも参照・変更できる。',
    code_example: <<~'RUBY',
      $app_name = "MyApp"

      def show_name
        puts $app_name
      end

      show_name  # => MyApp
    RUBY
    level: 2
  },
  {
    term: '定数',
    description: '大文字で始まる識別子。一度代入した値を変更しないことを意図する。変更しようとすると警告が出る。',
    code_example: <<~'RUBY',
      MAX_SIZE = 100
      PI = 3.14159

      puts MAX_SIZE  # => 100
      puts PI        # => 3.14159
    RUBY
    level: 1
  },
  {
    term: '多重代入',
    description: '複数の変数に一度に値を代入する構文。配列の分解にも使える。',
    code_example: <<~'RUBY',
      a, b, c = 1, 2, 3
      puts a  # => 1
      puts b  # => 2

      first, *rest = [10, 20, 30, 40]
      puts first  # => 10
      p rest      # => [20, 30, 40]
    RUBY
    level: 2
  },
  {
    term: '変数のスコープ',
    description: '変数が参照できる範囲のこと。ローカル変数はブロックやメソッド内に閉じているが、インスタンス変数はクラス内で共有される。',
    code_example: <<~'RUBY',
      x = 10

      3.times do
        y = 20
        puts x  # => 10（外側の変数は参照可能）
      end

      # puts y  # => NameError（ブロック外では参照不可）
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
