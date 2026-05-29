# Ruby - 繰り返し処理に関する用語のシードデータ

category = Category.find_or_create_by!(name: '繰り返し処理', large_category: @ruby_category)

words = [
  {
    term: 'each',
    description: '配列やハッシュなどの各要素に対してブロックを実行するメソッド。Rubyで最もよく使われる繰り返し処理。',
    code_example: <<~'RUBY',
      [1, 2, 3].each do |n|
        puts n
      end
      # => 1
      #    2
      #    3
    RUBY
    level: 1
  },
  {
    term: 'times',
    description: '指定した回数だけブロックを繰り返す Integer のメソッド。',
    code_example: <<~'RUBY',
      3.times do |i|
        puts "#{i}回目"
      end
      # => 0回目
      #    1回目
      #    2回目
    RUBY
    level: 1
  },
  {
    term: 'while',
    description: '条件が真の間ブロックを繰り返す。条件が偽になったとき終了する。',
    code_example: <<~'RUBY',
      count = 0

      while count < 3
        puts count
        count += 1
      end
      # => 0
      #    1
      #    2
    RUBY
    level: 1
  },
  {
    term: 'for',
    description: 'Range や配列の要素を1つずつ取り出して繰り返す。Rubyでは `each` が慣用的で `for` はあまり使われない。',
    code_example: <<~'RUBY',
      for i in 1..3
        puts i
      end
      # => 1
      #    2
      #    3
    RUBY
    level: 1
  },
  {
    term: 'loop',
    description: '無限ループを作るメソッド。`break` で抜け出すまで繰り返し続ける。',
    code_example: <<~'RUBY',
      count = 0

      loop do
        puts count
        count += 1
        break if count >= 3
      end
      # => 0
      #    1
      #    2
    RUBY
    level: 2
  },
  {
    term: 'each_with_index',
    description: '配列の各要素とそのインデックスをブロックに渡して繰り返す。',
    code_example: <<~'RUBY',
      fruits = ["apple", "banana", "cherry"]

      fruits.each_with_index do |fruit, i|
        puts "#{i}: #{fruit}"
      end
      # => 0: apple
      #    1: banana
      #    2: cherry
    RUBY
    level: 2
  },
  {
    term: 'upto/downto',
    description: '`upto` は数値を1ずつ増やしながら、`downto` は1ずつ減らしながらブロックを実行する Integer のメソッド。',
    code_example: <<~'RUBY',
      1.upto(3) { |i| print "#{i} " }
      # => 1 2 3

      3.downto(1) { |i| print "#{i} " }
      # => 3 2 1
    RUBY
    level: 2
  },
  {
    term: 'break',
    description: 'ループを途中で抜け出すキーワード。`break 値` のように値を返すこともできる。',
    code_example: <<~'RUBY',
      [1, 2, 3, 4, 5].each do |n|
        break if n == 3
        puts n
      end
      # => 1
      #    2
    RUBY
    level: 1
  },
  {
    term: 'next',
    description: '現在のイテレーションをスキップして次のループに進むキーワード。他の言語の `continue` に相当する。',
    code_example: <<~'RUBY',
      [1, 2, 3, 4, 5].each do |n|
        next if n.even?
        puts n
      end
      # => 1
      #    3
      #    5
    RUBY
    level: 1
  },
  {
    term: 'redo',
    description: '現在のイテレーションを最初からやり直すキーワード。使用頻度は低く、無限ループになりやすいため注意が必要。',
    code_example: <<~'RUBY',
      count = 0

      3.times do |i|
        count += 1
        redo if count == 2 && i == 0  # i=0 の処理を2回実行
        puts "i=#{i}, count=#{count}"
      end
      # => i=0, count=2
      #    i=1, count=3
      #    i=2, count=4
    RUBY
    level: 3
  },
  {
    term: 'step',
    description: '開始値から終了値まで、指定したステップ幅で繰り返す Numeric のメソッド。',
    code_example: <<~'RUBY',
      1.step(10, 2) { |i| print "#{i} " }
      # => 1 3 5 7 9

      (0.0).step(1.0, 0.5) { |f| print "#{f} " }
      # => 0.0 0.5 1.0
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
