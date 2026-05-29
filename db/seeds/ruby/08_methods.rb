# Ruby - メソッドに関する用語のシードデータ

category = Category.find_or_create_by!(name: 'メソッド', large_category: @ruby_category)

words = [
  {
    term: 'def/end',
    description: 'メソッドを定義するキーワード。`def メソッド名` で始まり `end` で終わる。',
    code_example: <<~'RUBY',
      def greet
        puts "Hello!"
      end

      greet  # => Hello!
    RUBY
    level: 1
  },
  {
    term: '引数',
    description: 'メソッドに渡す値。メソッド定義時に括弧内で変数名を宣言し、呼び出し時に値を渡す。',
    code_example: <<~'RUBY',
      def add(a, b)
        a + b
      end

      puts add(3, 4)  # => 7
    RUBY
    level: 1
  },
  {
    term: 'デフォルト引数',
    description: '引数に初期値を設定しておく機能。呼び出し時に引数を省略すると、デフォルト値が使われる。',
    code_example: <<~'RUBY',
      def greet(name = "World")
        puts "Hello, #{name}!"
      end

      greet          # => Hello, World!
      greet("Alice") # => Hello, Alice!
    RUBY
    level: 2
  },
  {
    term: 'キーワード引数',
    description: '引数名を指定して渡す方法。順序を気にせず渡せ、意味が明確になる。',
    code_example: <<~'RUBY',
      def create_user(name:, age:, role: "user")
        puts "#{name}（#{age}歳）: #{role}"
      end

      create_user(name: "Alice", age: 30)
      # => Alice（30歳）: user

      create_user(age: 25, name: "Bob", role: "admin")
      # => Bob（25歳）: admin
    RUBY
    level: 2
  },
  {
    term: '可変長引数',
    description: '引数の数が可変のメソッド定義。`*引数名` で任意の数の引数を配列として受け取る。',
    code_example: <<~'RUBY',
      def sum(*numbers)
        numbers.sum
      end

      puts sum(1, 2, 3)        # => 6
      puts sum(1, 2, 3, 4, 5)  # => 15
    RUBY
    level: 2
  },
  {
    term: '返り値',
    description: 'メソッドが呼び出し元に返す値。Rubyではメソッド内の最後に評価された式が自動的に返り値になる。',
    code_example: <<~'RUBY',
      def double(n)
        n * 2  # この値が返り値になる
      end

      result = double(5)
      puts result  # => 10
    RUBY
    level: 1
  },
  {
    term: 'return',
    description: 'メソッドから値を返して処理を中断するキーワード。早期リターンにも使われる。',
    code_example: <<~'RUBY',
      def check_age(age)
        return "未成年" if age < 18
        "成人"
      end

      puts check_age(15)  # => 未成年
      puts check_age(25)  # => 成人
    RUBY
    level: 1
  },
  {
    term: '破壊的メソッド',
    description: '末尾に `!` が付くメソッド。レシーバ自身を変更する（破壊的操作）。通常のメソッドは新しいオブジェクトを返す。',
    code_example: <<~'RUBY',
      str = "hello"

      puts str.upcase   # => HELLO
      puts str          # => hello（元のオブジェクトは変わらない）

      str.upcase!
      puts str          # => HELLO（レシーバ自身が変更される）
    RUBY
    level: 2
  },
  {
    term: '述語メソッド',
    description: '末尾に `?` が付くメソッド。真偽値（true/false）を返すことを示す慣習。',
    code_example: <<~'RUBY',
      puts "".empty?       # => true
      puts [1, 2].empty?   # => false
      puts 5.odd?          # => true
      puts 4.even?         # => true
      puts nil.nil?        # => true
    RUBY
    level: 2
  },
  {
    term: 'メソッドの別名',
    description: '`alias` または `alias_method` で既存メソッドに別名を付ける。既存メソッドをオーバーライドしつつ元の処理を呼び出す際などに使う。',
    code_example: <<~'RUBY',
      class MyString
        def greet
          "Hello!"
        end

        alias say_hello greet
      end

      s = MyString.new
      puts s.greet      # => Hello!
      puts s.say_hello  # => Hello!
    RUBY
    level: 3
  },
  {
    term: 'method_missing',
    description: '定義されていないメソッドが呼ばれたときに自動で実行される特殊なメソッド。動的なメソッド定義などに使われる。',
    code_example: <<~'RUBY',
      class DynamicClass
        def method_missing(name, *args)
          if name.to_s.start_with?("say_")
            puts name.to_s.sub("say_", "")
          else
            super
          end
        end
      end

      obj = DynamicClass.new
      obj.say_hello  # => hello
      obj.say_world  # => world
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
