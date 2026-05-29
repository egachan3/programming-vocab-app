# Ruby - 配列とイテレータに関する用語のシードデータ

category = Category.find_or_create_by!(name: '配列とイテレータ', large_category: @ruby_category)

words = [
  {
    term: '配列の作成',
    description: '`[]` リテラルまたは `Array.new` で配列を作成する。複数の型を混在させることもできる。',
    code_example: <<~'RUBY',
      nums = [1, 2, 3]
      words = ["apple", "banana"]
      mixed = [1, "two", :three, nil]

      p Array.new(3, 0)   # => [0, 0, 0]
      p Array.new(3) { |i| i * 2 }  # => [0, 2, 4]
    RUBY
    level: 1
  },
  {
    term: 'push/<<',
    description: '配列の末尾に要素を追加するメソッド。`push` と `<<` は同じ動作をする。',
    code_example: <<~'RUBY',
      arr = [1, 2]
      arr.push(3)
      arr << 4
      p arr  # => [1, 2, 3, 4]
    RUBY
    level: 1
  },
  {
    term: 'pop',
    description: '配列の末尾から要素を取り出して返す破壊的メソッド。',
    code_example: <<~'RUBY',
      arr = [1, 2, 3]
      last = arr.pop
      puts last  # => 3
      p arr      # => [1, 2]
    RUBY
    level: 1
  },
  {
    term: 'shift/unshift',
    description: '`shift` は先頭の要素を取り出し、`unshift` は先頭に要素を追加する破壊的メソッド。',
    code_example: <<~'RUBY',
      arr = [1, 2, 3]
      first = arr.shift
      puts first  # => 1
      p arr       # => [2, 3]

      arr.unshift(0)
      p arr  # => [0, 2, 3]
    RUBY
    level: 2
  },
  {
    term: 'first/last',
    description: '配列の先頭または末尾の要素を返すメソッド。引数に数値を渡すと複数の要素を配列で返す。',
    code_example: <<~'RUBY',
      arr = [10, 20, 30, 40, 50]
      puts arr.first   # => 10
      puts arr.last    # => 50
      p arr.first(2)   # => [10, 20]
      p arr.last(3)    # => [30, 40, 50]
    RUBY
    level: 1
  },
  {
    term: 'length/size',
    description: '配列の要素数を返すメソッド。`length` と `size` は同じ動作をする。',
    code_example: <<~'RUBY',
      arr = [1, 2, 3, 4, 5]
      puts arr.length  # => 5
      puts arr.size    # => 5
      puts [].empty?   # => true
    RUBY
    level: 1
  },
  {
    term: 'flatten',
    description: 'ネストした配列を平坦化して返す。引数で平坦化する深さを指定できる。',
    code_example: <<~'RUBY',
      arr = [1, [2, 3], [4, [5, 6]]]
      p arr.flatten    # => [1, 2, 3, 4, 5, 6]
      p arr.flatten(1) # => [1, 2, 3, 4, [5, 6]]
    RUBY
    level: 2
  },
  {
    term: 'compact',
    description: '配列から `nil` を除いた新しい配列を返す。`compact!` は元の配列を変更する。',
    code_example: <<~'RUBY',
      arr = [1, nil, 2, nil, 3]
      p arr.compact  # => [1, 2, 3]
      p arr          # => [1, nil, 2, nil, 3]（元は変更されない）
    RUBY
    level: 2
  },
  {
    term: 'uniq',
    description: '配列から重複する要素を除いた新しい配列を返す。',
    code_example: <<~'RUBY',
      arr = [1, 2, 2, 3, 3, 3]
      p arr.uniq  # => [1, 2, 3]
    RUBY
    level: 2
  },
  {
    term: 'sort/sort_by',
    description: '`sort` は配列を昇順に並び替え、`sort_by` はブロックの戻り値を基準に並び替える。',
    code_example: <<~'RUBY',
      p [3, 1, 2].sort           # => [1, 2, 3]
      p [3, 1, 2].sort { |a, b| b <=> a }  # => [3, 2, 1]（降順）

      words = ["banana", "apple", "cherry"]
      p words.sort_by { |w| w.length }  # => ["apple", "banana", "cherry"]
    RUBY
    level: 2
  },
  {
    term: 'reverse',
    description: '配列の要素を逆順にした新しい配列を返す。',
    code_example: <<~'RUBY',
      p [1, 2, 3].reverse    # => [3, 2, 1]
      p "hello".reverse      # => "olleh"
    RUBY
    level: 1
  },
  {
    term: 'include?',
    description: '指定した要素が配列に含まれているかどうかを返す述語メソッド。',
    code_example: <<~'RUBY',
      arr = [1, 2, 3]
      puts arr.include?(2)   # => true
      puts arr.include?(5)   # => false
    RUBY
    level: 1
  },
  {
    term: 'map',
    description: '各要素にブロックを適用し、結果の配列を返すメソッド。`collect` とも呼ばれる。',
    code_example: <<~'RUBY',
      nums = [1, 2, 3, 4]
      p nums.map { |n| n * 2 }      # => [2, 4, 6, 8]
      p nums.map { |n| n.to_s }     # => ["1", "2", "3", "4"]
    RUBY
    level: 2
  },
  {
    term: 'select',
    description: 'ブロックの戻り値が真の要素だけを集めた配列を返す。`filter` とも呼ばれる。',
    code_example: <<~'RUBY',
      nums = [1, 2, 3, 4, 5, 6]
      p nums.select { |n| n.even? }    # => [2, 4, 6]
      p nums.select { |n| n > 3 }      # => [4, 5, 6]
    RUBY
    level: 2
  },
  {
    term: 'reject',
    description: 'ブロックの戻り値が真の要素を除いた配列を返す。`select` の逆。',
    code_example: <<~'RUBY',
      nums = [1, 2, 3, 4, 5, 6]
      p nums.reject { |n| n.even? }    # => [1, 3, 5]
      p nums.reject { |n| n > 3 }      # => [1, 2, 3]
    RUBY
    level: 2
  },
  {
    term: 'find',
    description: 'ブロックの戻り値が最初に真になった要素を返す。見つからなければ `nil`。`detect` とも呼ばれる。',
    code_example: <<~'RUBY',
      nums = [1, 2, 3, 4, 5]
      puts nums.find { |n| n > 3 }   # => 4
      puts nums.find { |n| n > 10 }.inspect  # => nil
    RUBY
    level: 2
  },
  {
    term: 'reduce',
    description: '配列の要素を順番に処理して1つの値にまとめるメソッド。`inject` とも呼ばれる。',
    code_example: <<~'RUBY',
      nums = [1, 2, 3, 4, 5]
      sum = nums.reduce(0) { |acc, n| acc + n }
      puts sum  # => 15

      # シンボルで渡す書き方
      puts nums.reduce(:+)  # => 15
    RUBY
    level: 3
  },
  {
    term: 'each_with_object',
    description: '各要素を処理しながら指定したオブジェクトを構築していくメソッド。配列やハッシュを組み立てるのに便利。',
    code_example: <<~'RUBY',
      result = [1, 2, 3].each_with_object([]) do |n, arr|
        arr << n * 2
      end
      p result  # => [2, 4, 6]
    RUBY
    level: 3
  },
  {
    term: 'zip',
    description: '複数の配列を対応する位置で組み合わせ、配列の配列を返す。',
    code_example: <<~'RUBY',
      a = [1, 2, 3]
      b = ["a", "b", "c"]
      p a.zip(b)  # => [[1, "a"], [2, "b"], [3, "c"]]
    RUBY
    level: 3
  },
  {
    term: 'flat_map',
    description: '`map` した結果を1段階平坦化するメソッド。`map` + `flatten(1)` と同じ。',
    code_example: <<~'RUBY',
      p [[1, 2], [3, 4]].flat_map { |a| a }
      # => [1, 2, 3, 4]

      p [1, 2, 3].flat_map { |n| [n, n * 2] }
      # => [1, 2, 2, 4, 3, 6]
    RUBY
    level: 3
  },
  {
    term: 'count',
    description: '要素数を返す。ブロックを渡すと条件に一致する要素数を返す。引数を渡すと一致する要素数を返す。',
    code_example: <<~'RUBY',
      arr = [1, 2, 3, 2, 1]
      puts arr.count           # => 5
      puts arr.count(2)        # => 2
      puts arr.count { |n| n > 1 }  # => 3
    RUBY
    level: 2
  },
  {
    term: 'any?/all?/none?',
    description: '`any?` はいずれかが真なら true、`all?` は全て真なら true、`none?` は全て偽なら true を返す述語メソッド。',
    code_example: <<~'RUBY',
      nums = [1, 2, 3, 4, 5]
      puts nums.any? { |n| n > 4 }   # => true
      puts nums.all? { |n| n > 0 }   # => true
      puts nums.none? { |n| n > 10 } # => true
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
