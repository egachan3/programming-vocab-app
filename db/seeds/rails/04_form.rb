# Rails - フォームに関する用語のシードデータ

category = Category.find_or_create_by!(name: 'フォーム', large_category: @rails_category)

words = [
  # ===== Level 1 =====
  {
    term: 'form_with',
    description: 'HTMLフォームを生成するヘルパーメソッド。Rails 5.1以降の推奨の書き方。モデルオブジェクトを渡すとURLやHTTPメソッドを自動で判断する。URLを直接指定することもできる。',
    code_example: <<~'ERB',
      <%# モデルを使う場合（新規作成・編集に自動対応）%>
      <%= form_with model: @user do |f| %>
        <%= f.label :name, "名前" %>
        <%= f.text_field :name %>
        <%= f.submit %>
      <% end %>

      <%# URLを直接指定する場合 %>
      <%= form_with url: search_path, method: :get do |f| %>
        <%= f.text_field :q %>
        <%= f.submit "検索" %>
      <% end %>
    ERB
    level: 1
  },
  {
    term: 'label',
    description: 'フォームのラベル（<label>タグ）を生成するヘルパーメソッド。for属性が自動的に対応するフィールドのidと紐付く。アクセシビリティの観点から入力項目には必ず付けることが推奨される。',
    code_example: <<~'ERB',
      <%= f.label :name %>
      <%= f.label :name, "お名前" %>
      <%= f.label :name, "お名前", class: "required" %>
    ERB
    level: 1
  },
  {
    term: 'text_field',
    description: 'テキスト入力フィールド（<input type="text">）を生成するヘルパーメソッド。モデルの属性値が自動的にvalueに入る。',
    code_example: <<~'ERB',
      <%= f.text_field :name %>
      <%= f.text_field :name, placeholder: "名前を入力", class: "form-control" %>
    ERB
    level: 1
  },
  {
    term: 'password_field',
    description: 'パスワード入力フィールド（<input type="password">）を生成するヘルパーメソッド。入力内容が●で隠される。',
    code_example: <<~'ERB',
      <%= f.password_field :password %>
      <%= f.password_field :password, placeholder: "8文字以上" %>
    ERB
    level: 1
  },
  {
    term: 'email_field',
    description: 'メールアドレス入力フィールド（<input type="email">）を生成するヘルパーメソッド。スマートフォンではメールアドレス用キーボードが表示される。',
    code_example: <<~'ERB',
      <%= f.email_field :email %>
      <%= f.email_field :email, placeholder: "example@mail.com" %>
    ERB
    level: 1
  },
  {
    term: 'text_area',
    description: '複数行テキスト入力エリア（<textarea>）を生成するヘルパーメソッド。rows・cols属性で表示サイズを指定できる。',
    code_example: <<~'ERB',
      <%= f.text_area :body %>
      <%= f.text_area :body, rows: 10, placeholder: "本文を入力してください" %>
    ERB
    level: 1
  },
  {
    term: 'check_box',
    description: 'チェックボックス（<input type="checkbox">）を生成するヘルパーメソッド。チェック時は1・未チェック時は0がパラメータに送られる。',
    code_example: <<~'ERB',
      <%= f.check_box :agree %>
      <%= f.label :agree, "利用規約に同意する" %>
    ERB
    level: 1
  },
  {
    term: 'radio_button',
    description: 'ラジオボタン（<input type="radio">）を生成するヘルパーメソッド。同じ属性名で複数生成すると1つだけ選択できる。',
    code_example: <<~'ERB',
      <%= f.radio_button :role, "admin" %>
      <%= f.label :role_admin, "管理者" %>
      <%= f.radio_button :role, "user" %>
      <%= f.label :role_user, "一般ユーザー" %>
    ERB
    level: 1
  },
  {
    term: 'select',
    description: 'プルダウンメニュー（<select>タグ）を生成するヘルパーメソッド。選択肢の配列またはoptions_for_selectで生成したオプションを渡す。',
    code_example: <<~'ERB',
      <%= f.select :category, ["技術", "ビジネス", "趣味"] %>
      <%= f.select :status,
          [["公開", "published"], ["非公開", "draft"]],
          { prompt: "選択してください" } %>
    ERB
    level: 1
  },
  {
    term: 'hidden_field',
    description: '非表示フィールド（<input type="hidden">）を生成するヘルパーメソッド。ユーザーには見えないがフォーム送信時に値を一緒に送りたいときに使う。',
    code_example: <<~'ERB',
      <%= f.hidden_field :user_id %>
      <%= f.hidden_field :token, value: @token %>
    ERB
    level: 1
  },
  {
    term: 'file_field',
    description: 'ファイル選択フィールド（<input type="file">）を生成するヘルパーメソッド。画像や添付ファイルのアップロードに使う。フォームにはmultipart: trueが必要。',
    code_example: <<~'ERB',
      <%= form_with model: @user, html: { multipart: true } do |f| %>
        <%= f.file_field :avatar %>
        <%= f.file_field :documents, multiple: true %>
      <% end %>
    ERB
    level: 1
  },
  {
    term: 'submit',
    description: '送信ボタン（<input type="submit">）を生成するヘルパーメソッド。引数を省略するとモデルの状態に応じて「Create モデル名」「Update モデル名」と自動で表示される。',
    code_example: <<~'ERB',
      <%= f.submit %>
      <%= f.submit "保存する" %>
      <%= f.submit "登録", class: "btn btn-primary" %>
    ERB
    level: 1
  },

  # ===== Level 2 =====
  {
    term: 'form_for',
    description: 'モデルオブジェクトに紐付いたフォームを生成する旧来のヘルパーメソッド。Rails 5.1以降はform_withに統合されたため、新規コードではform_withを使うことが推奨される。',
    code_example: <<~'ERB',
      <%# Rails 5.0以前の書き方（現在はform_withを推奨）%>
      <%= form_for @user do |f| %>
        <%= f.text_field :name %>
        <%= f.submit %>
      <% end %>
    ERB
    level: 2
  },
  {
    term: 'form_tag',
    description: 'URLを指定してフォームを生成する旧来のヘルパーメソッド。モデルと紐付かないフォームに使っていたが、Rails 5.1以降はform_withに統合された。',
    code_example: <<~'ERB',
      <%# Rails 5.0以前の書き方（現在はform_withを推奨）%>
      <%= form_tag search_path, method: :get do %>
        <%= text_field_tag :q %>
        <%= submit_tag "検索" %>
      <% end %>
    ERB
    level: 2
  },
  {
    term: 'fields_for',
    description: 'ネストされたモデルのフィールドを生成するヘルパーメソッド。accepts_nested_attributes_forと組み合わせて関連モデルのフォームを1つのフォームで扱うときに使う。',
    code_example: <<~'ERB',
      <%= form_with model: @user do |f| %>
        <%= f.text_field :name %>

        <%= f.fields_for :address do |addr| %>
          <%= addr.text_field :city %>
          <%= addr.text_field :zip %>
        <% end %>

        <%= f.submit %>
      <% end %>
    ERB
    level: 2
  },
  {
    term: 'fields',
    description: 'fields_forのRails 7以降の新しい書き方。form_withのブロック変数から呼び出す。ネストされたモデルのフォームをより簡潔に記述できる。',
    code_example: <<~'ERB',
      <%= form_with model: @user do |f| %>
        <%= f.fields :address do |addr| %>
          <%= addr.text_field :city %>
        <% end %>
      <% end %>
    ERB
    level: 2
  },
  {
    term: 'number_field',
    description: '数値入力フィールド（<input type="number">）を生成するヘルパーメソッド。min・max・stepで入力範囲を指定できる。',
    code_example: <<~'ERB',
      <%= f.number_field :age, min: 0, max: 120 %>
      <%= f.number_field :price, min: 0, step: 100 %>
    ERB
    level: 2
  },
  {
    term: 'collection_select',
    description: 'Active Recordのコレクションからプルダウンメニューを生成するヘルパーメソッド。オプションのvalue・テキストに使う属性名を指定する。',
    code_example: <<~'ERB',
      <%# カテゴリ一覧からプルダウンを生成 %>
      <%= f.collection_select :category_id, Category.all, :id, :name,
          { prompt: "カテゴリを選択" } %>
    ERB
    level: 2
  },
  {
    term: 'options_for_select',
    description: 'selectヘルパーに渡すオプションのHTML文字列を生成するヘルパーメソッド。配列やハッシュから生成する。',
    code_example: <<~'ERB',
      <%= f.select :status,
          options_for_select([["公開", "published"], ["下書き", "draft"]], "published") %>
    ERB
    level: 2
  },
  {
    term: 'options_from_collection_for_select',
    description: 'Active RecordのコレクションからオプションのHTML文字列を生成するヘルパーメソッド。collection_selectより細かい制御が必要な場合に使う。',
    code_example: <<~'ERB',
      <%= f.select :category_id,
          options_from_collection_for_select(Category.all, :id, :name, @article.category_id) %>
    ERB
    level: 2
  },
  {
    term: 'collection_check_boxes',
    description: 'Active Recordのコレクションからチェックボックスの一覧を生成するヘルパーメソッド。多対多の関連で複数選択できるフォームに使う。',
    code_example: <<~'ERB',
      <%= f.collection_check_boxes :tag_ids, Tag.all, :id, :name %>
    ERB
    level: 2
  },
  {
    term: 'collection_radio_buttons',
    description: 'Active Recordのコレクションからラジオボタンの一覧を生成するヘルパーメソッド。関連モデルから1つを選択するフォームに使う。',
    code_example: <<~'ERB',
      <%= f.collection_radio_buttons :category_id, Category.all, :id, :name %>
    ERB
    level: 2
  },
  {
    term: 'date_field',
    description: '日付入力フィールド（<input type="date">）を生成するヘルパーメソッド。ブラウザ標準の日付ピッカーが表示される。',
    code_example: <<~'ERB',
      <%= f.date_field :birthday %>
      <%= f.date_field :published_on, min: Date.today %>
    ERB
    level: 2
  },
  {
    term: 'search_field',
    description: '検索入力フィールド（<input type="search">）を生成するヘルパーメソッド。text_fieldと似ているがブラウザによってはクリアボタンが表示される。',
    code_example: <<~'ERB',
      <%= f.search_field :q, placeholder: "検索ワードを入力" %>
    ERB
    level: 2
  },

  # ===== Level 3 =====
  {
    term: 'rich_text_area',
    description: 'Action TextのリッチテキストエディタTrixを埋め込むヘルパーメソッド。rails action_text:installを実行後に使える。書式付きテキストの入力に使う。',
    code_example: <<~'ERB',
      <%= f.rich_text_area :content %>
    ERB
    level: 3
  },
  {
    term: 'time_zone_select',
    description: 'タイムゾーンを選択するプルダウンを生成するヘルパーメソッド。ユーザーのタイムゾーン設定機能を実装するときに使う。',
    code_example: <<~'ERB',
      <%= f.time_zone_select :time_zone,
          ActiveSupport::TimeZone.us_zones,
          { default: "Tokyo" } %>
    ERB
    level: 3
  },
  {
    term: 'date_select',
    description: '年・月・日のプルダウンを3つ生成するヘルパーメソッド。date_fieldより古い方式で、ブラウザのネイティブUIを使わない場合に使う。',
    code_example: <<~'ERB',
      <%= f.date_select :birthday, start_year: 1900, end_year: Date.today.year %>
    ERB
    level: 3
  },
  {
    term: 'datetime_select',
    description: '年・月・日・時・分のプルダウンをまとめて生成するヘルパーメソッド。日時の入力をプルダウン形式で行いたいときに使う。',
    code_example: <<~'ERB',
      <%= f.datetime_select :published_at %>
    ERB
    level: 3
  },
  {
    term: 'grouped_collection_select',
    description: 'グループ化されたプルダウン（<optgroup>）をActive Recordのコレクションから生成するヘルパーメソッド。カテゴリとサブカテゴリのような階層構造の選択肢に使う。',
    code_example: <<~'ERB',
      <%# 大カテゴリでグループ化した中カテゴリの選択 %>
      <%= f.grouped_collection_select :category_id,
          LargeCategory.all, :categories, :name,
          :id, :name %>
    ERB
    level: 3
  },
  {
    term: 'weekday_select',
    description: '曜日を選択するプルダウンを生成するヘルパーメソッド。定期的なスケジュール設定などに使う。',
    code_example: <<~'ERB',
      <%= f.weekday_select :weekday %>
    ERB
    level: 3
  },
  {
    term: 'range_field',
    description: '範囲スライダー（<input type="range">）を生成するヘルパーメソッド。スライダーで数値を入力させたいときに使う。',
    code_example: <<~'ERB',
      <%= f.range_field :volume, min: 0, max: 100, step: 5 %>
    ERB
    level: 3
  },
  {
    term: 'distance_of_time_in_words',
    description: '2つの時刻の差を「約3分」「1日以上」などの自然な言葉で返すヘルパーメソッド。time_ago_in_wordsはこのメソッドを現在時刻との差に特化させたもの。',
    code_example: <<~'ERB',
      <%= distance_of_time_in_words(Time.now, 3.hours.from_now) %>
      <%# => "約3時間" %>

      <%= distance_of_time_in_words(article.created_at, article.updated_at) %>
    ERB
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
