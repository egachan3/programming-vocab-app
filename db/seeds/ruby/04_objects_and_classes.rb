# Ruby - オブジェクトとクラスの基本に関する用語のシードデータ

category = Category.find_or_create_by!(name: 'オブジェクトとクラスの基本', large_category: @ruby_category)

words = [
  {
    term: 'オブジェクト',
    description: 'データ（属性）とメソッド（振る舞い）をまとめた基本単位。Rubyではほぼすべての値がオブジェクト。',
    code_example: <<~'RUBY',
      puts 42.class        # => Integer
      puts "hello".class   # => String
      puts true.class      # => TrueClass
      puts nil.class       # => NilClass
    RUBY
    level: 1
  },
  {
    term: 'クラス',
    description: 'オブジェクトの設計図。属性（インスタンス変数）と振る舞い（メソッド）を定義する。',
    code_example: <<~'RUBY',
      class Dog
        def bark
          puts "Woof!"
        end
      end

      dog = Dog.new
      dog.bark  # => Woof!
    RUBY
    level: 1
  },
  {
    term: 'インスタンス',
    description: 'クラスから `new` メソッドで生成された具体的なオブジェクト。',
    code_example: <<~'RUBY',
      class Cat; end

      cat1 = Cat.new
      cat2 = Cat.new

      puts cat1.class  # => Cat
      puts cat1.equal?(cat2)  # => false（別オブジェクト）
    RUBY
    level: 1
  },
  {
    term: 'initialize',
    description: 'インスタンス生成時（`new` 呼び出し時）に自動で呼ばれる特殊なメソッド。初期化処理を書く。',
    code_example: <<~'RUBY',
      class Person
        def initialize(name, age)
          @name = name
          @age = age
        end
      end

      person = Person.new("Alice", 30)
    RUBY
    level: 1
  },
  {
    term: 'attr_accessor',
    description: 'インスタンス変数の読み取り（ゲッター）と書き込み（セッター）メソッドを一括定義するマクロ。',
    code_example: <<~'RUBY',
      class Person
        attr_accessor :name, :age
      end

      p = Person.new
      p.name = "Bob"
      p.age = 25
      puts p.name  # => Bob
      puts p.age   # => 25
    RUBY
    level: 1
  },
  {
    term: 'attr_reader',
    description: 'インスタンス変数の読み取りメソッド（ゲッター）のみを定義するマクロ。外部からの書き込みを禁止したい場合に使う。',
    code_example: <<~'RUBY',
      class Product
        attr_reader :price

        def initialize(price)
          @price = price
        end
      end

      product = Product.new(1000)
      puts product.price  # => 1000
      # product.price = 2000  # => NoMethodError
    RUBY
    level: 2
  },
  {
    term: 'attr_writer',
    description: 'インスタンス変数への書き込みメソッド（セッター）のみを定義するマクロ。外部からの読み取りを禁止したい場合に使う。',
    code_example: <<~'RUBY',
      class Config
        attr_writer :debug

        def initialize
          @debug = false
        end
      end

      config = Config.new
      config.debug = true
      # puts config.debug  # => NoMethodError
    RUBY
    level: 2
  },
  {
    term: 'self',
    description: '現在のコンテキストにおけるオブジェクト自身を参照するキーワード。メソッド内では呼び出し元のインスタンス、クラス定義内ではクラス自身を指す。',
    code_example: <<~'RUBY',
      class MyClass
        def who_am_i
          puts self        # => #<MyClass:0x...>
          puts self.class  # => MyClass
        end
      end

      MyClass.new.who_am_i
    RUBY
    level: 2
  },
  {
    term: 'クラスメソッド',
    description: 'クラス自身に対して呼び出せるメソッド。`def self.メソッド名` で定義する。インスタンスなしで呼べる。',
    code_example: <<~'RUBY',
      class MathHelper
        def self.square(n)
          n * n
        end
      end

      puts MathHelper.square(5)  # => 25
    RUBY
    level: 2
  },
  {
    term: 'インスタンスメソッド',
    description: 'クラスのインスタンスに対して呼び出せるメソッド。`def メソッド名` で定義する。',
    code_example: <<~'RUBY',
      class Greeter
        def say_hello
          puts "Hello!"
        end
      end

      g = Greeter.new
      g.say_hello  # => Hello!
    RUBY
    level: 1
  },
  {
    term: 'to_s',
    description: 'オブジェクトを文字列に変換するメソッド。`puts` や文字列結合時に自動で呼ばれる。クラスでオーバーライドして独自の文字列表現を定義できる。',
    code_example: <<~'RUBY',
      class Point
        def initialize(x, y)
          @x = x
          @y = y
        end

        def to_s
          "(#{@x}, #{@y})"
        end
      end

      p = Point.new(3, 4)
      puts p  # => (3, 4)
    RUBY
    level: 2
  },
  {
    term: 'inspect',
    description: 'オブジェクトの詳細情報を文字列で返すメソッド。`p` メソッドで呼ばれる。デバッグ用途向けに、オブジェクトの内部状態を分かりやすく表示する。',
    code_example: <<~'RUBY',
      class Point
        def initialize(x, y)
          @x = x
          @y = y
        end

        def inspect
          "#<Point x=#{@x}, y=#{@y}>"
        end
      end

      p Point.new(1, 2)  # => #<Point x=1, y=2>
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
