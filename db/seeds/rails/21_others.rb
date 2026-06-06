# Rails - その他に関する用語のシードデータ

category = Category.find_or_create_by!(name: 'その他', large_category: @rails_category)

words = [
  {
    term: 'アセットパイプライン',
    description: 'JavaScript・CSS・画像などの静的ファイルを連結・圧縮・ダイジェスト付加して配信する仕組み。Sprocketsまたはpropshaftが担当する。本番環境ではrails assets:precompileで事前にビルドしてから配信する。',
    code_example: <<~'SHELL',
      # アセットのコンパイル（本番デプロイ前に実行）
      rails assets:precompile

      # コンパイル済みアセットの削除
      rails assets:clean

      # すべてのコンパイル済みアセットを削除
      rails assets:clobber
    SHELL
    level: 1
  },
  {
    term: 'フィンガープリンティング',
    description: 'アセットファイルの内容をハッシュ化した文字列をファイル名に付加する仕組み。ファイルが変更されるとハッシュが変わりファイル名が変わるため、ブラウザのキャッシュを自動的に無効化できる。例：application-abc123.css。config.assets.digest = trueで有効になる。',
    code_example: <<~'SHELL',
      # フィンガープリントなし
      application.css

      # フィンガープリントあり（本番環境）
      application-8e35a6f1c2d3b4a5.css

      # ビューではasset_pathヘルパーが自動でフィンガープリント付きのパスを生成する
      # <%= stylesheet_link_tag "application" %>
      # => <link href="/assets/application-8e35a6f1c2d3b4a5.css" rel="stylesheet">
    SHELL
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
