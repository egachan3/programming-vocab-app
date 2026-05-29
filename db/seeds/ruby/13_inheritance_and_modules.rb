# Ruby - 継承とモジュールに関する用語のシードデータ

category = Category.find_or_create_by!(name: '継承とモジュール', large_category: @ruby_category)

words = [
  {
    term: '継承',
    description: 'あるクラスが別のクラスの属性やメソッドを引き継ぐ機能。`class 子クラス < 親クラス` で定義する。',
    code_example: <<~'RUBY',
      class Animal
        def speak
          puts "..."
        end
      end

      class Dog < Animal
        def speak
          puts "Woof!"
        end
      end

      Dog.new.speak  # => Woof!
      puts Dog.superclass  # => Animal
    RUBY
    level: 2
  },
  {
    term: 'super',
    description: '親クラスの同名メソッドを呼び出すキーワード。引数を渡す場合は `super(引数)`、そのまま転送するには `super` のみ書く。',
    code_example: <<~'RUBY',
      class Animal
        def initialize(name)
          @name = name
        end
      end

      class Dog < Animal
        def initialize(name, breed)
          super(name)  # 親クラスの initialize を呼ぶ
          @breed = breed
        end
      end

      dog = Dog.new("Pochi", "Shiba")
    RUBY
    level: 2
  },
  {
    term: 'オーバーライド',
    description: '子クラスで親クラスと同名のメソッドを定義し、動作を上書きすること。',
    code_example: <<~'RUBY',
      class Shape
        def area
          0
        end
      end

      class Square < Shape
        def initialize(side)
          @side = side
        end

        def area
          @side ** 2
        end
      end

      puts Square.new(4).area  # => 16
    RUBY
    level: 2
  },
  {
    term: 'module',
    description: 'メソッドや定数をまとめる名前空間。クラスとは異なり、インスタンスを作れない。`include` や `extend` でクラスに取り込む。',
    code_example: <<~'RUBY',
      module Greetable
        def greet
          puts "Hello, I'm #{name}!"
        end
      end

      class Person
        include Greetable
        attr_reader :name

        def initialize(name)
          @name = name
        end
      end

      Person.new("Alice").greet  # => Hello, I'm Alice!
    RUBY
    level: 2
  },
  {
    term: 'include',
    description: 'モジュールのメソッドをインスタンスメソッドとして取り込む。インスタンスに対してメソッドを呼び出せるようになる。',
    code_example: <<~'RUBY',
      module Swim
        def swim
          puts "swimming!"
        end
      end

      class Duck
        include Swim
      end

      Duck.new.swim  # => swimming!
    RUBY
    level: 2
  },
  {
    term: 'extend',
    description: 'モジュールのメソッドをクラスメソッドとして取り込む。インスタンスではなくクラス自身に対して呼び出せるようになる。',
    code_example: <<~'RUBY',
      module ClassMethods
        def create
          puts "Creating #{self}..."
        end
      end

      class MyClass
        extend ClassMethods
      end

      MyClass.create  # => Creating MyClass...
    RUBY
    level: 3
  },
  {
    term: 'mixin',
    description: '`include` や `extend` でモジュールをクラスに取り込んで機能を追加するデザインパターン。多重継承の代替として使われる。',
    code_example: <<~'RUBY',
      module Flyable
        def fly
          puts "flying!"
        end
      end

      module Swimmable
        def swim
          puts "swimming!"
        end
      end

      class Duck
        include Flyable
        include Swimmable
      end

      duck = Duck.new
      duck.fly   # => flying!
      duck.swim  # => swimming!
    RUBY
    level: 2
  },
  {
    term: 'Comparable',
    description: '`<=>` 演算子を定義して `include` すると、`<` `>` `<=` `>=` `between?` などの比較メソッドが自動で使えるようになるモジュール。',
    code_example: <<~'RUBY',
      class Temperature
        include Comparable

        attr_reader :degrees

        def initialize(degrees)
          @degrees = degrees
        end

        def <=>(other)
          degrees <=> other.degrees
        end
      end

      cold = Temperature.new(10)
      hot  = Temperature.new(30)

      puts cold < hot   # => true
      puts hot.between?(Temperature.new(20), Temperature.new(40))  # => true
    RUBY
    level: 3
  },
  {
    term: 'Enumerable',
    description: '`each` を定義して `include` すると、`map`, `select`, `sort`, `min`, `max` など多数のイテレータが自動で使えるようになるモジュール。',
    code_example: <<~'RUBY',
      class NumberList
        include Enumerable

        def initialize(*nums)
          @nums = nums
        end

        def each(&block)
          @nums.each(&block)
        end
      end

      list = NumberList.new(3, 1, 4, 1, 5)
      p list.sort          # => [1, 1, 3, 4, 5]
      p list.select(&:odd?) # => [3, 1, 1, 5]
    RUBY
    level: 3
  },
  {
    term: '名前空間',
    description: 'モジュールを使って定数やクラスをグループ化し、名前の衝突を防ぐ仕組み。`::` で階層を区切ってアクセスする。',
    code_example: <<~'RUBY',
      module MyApp
        module Auth
          class User
            def initialize(name)
              @name = name
            end
          end
        end
      end

      user = MyApp::Auth::User.new("Alice")
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
