# Rails - コールバックに関する用語のシードデータ

category = Category.find_or_create_by!(name: 'コールバック', large_category: @rails_category)

words = [
  # ===== Level 1 =====
  {
    term: 'before_action',
    description: 'コントローラーのアクションが実行される前に処理を行うコールバック。認証チェックや共通のデータ取得などに使う。onlyやexceptで対象アクションを絞れる。',
    code_example: <<~'RUBY',
      class ArticlesController < ApplicationController
        before_action :authenticate_user!
        before_action :set_article, only: [:show, :edit, :update, :destroy]

        private

        def set_article
          @article = Article.find(params[:id])
        end
      end
    RUBY
    level: 1
  },
  {
    term: 'after_action',
    description: 'コントローラーのアクションが実行された後に処理を行うコールバック。ログの記録や後処理に使う。',
    code_example: <<~'RUBY',
      class ApplicationController < ActionController::Base
        after_action :log_action

        private

        def log_action
          logger.info "#{controller_name}##{action_name} が実行されました"
        end
      end
    RUBY
    level: 1
  },
  {
    term: 'around_action',
    description: 'コントローラーのアクションの前後を囲んで処理を行うコールバック。yieldでアクション本体を呼び出す。処理時間の計測やトランザクション管理などに使う。',
    code_example: <<~'RUBY',
      class ApplicationController < ActionController::Base
        around_action :measure_time

        private

        def measure_time
          start = Time.current
          yield
          elapsed = Time.current - start
          logger.info "処理時間: #{elapsed}秒"
        end
      end
    RUBY
    level: 1
  },
  {
    term: 'skip_before_action',
    description: '親クラスやモジュールで定義されたbefore_actionをスキップするメソッド。ログイン不要なページで認証をスキップするときによく使う。',
    code_example: <<~'RUBY',
      class PagesController < ApplicationController
        skip_before_action :authenticate_user!
        # 全アクションで認証をスキップ

        skip_before_action :authenticate_user!, only: [:top, :about]
        # 指定アクションのみスキップ
      end
    RUBY
    level: 1
  },
  {
    term: 'after_initialize',
    description: 'モデルオブジェクトが初期化（new または find）された直後に実行されるモデルコールバック。デフォルト値の設定などに使う。',
    code_example: <<~'RUBY',
      class User < ApplicationRecord
        after_initialize :set_default_role

        private

        def set_default_role
          self.role ||= "member"
        end
      end

      User.new.role   # => "member"
    RUBY
    level: 1
  },

  # ===== Level 2 =====
  {
    term: 'after_touch',
    description: 'touchメソッドが呼ばれた後に実行されるモデルコールバック。キャッシュの無効化などに使う。',
    code_example: <<~'RUBY',
      class Article < ApplicationRecord
        belongs_to :user, touch: true
        after_touch :clear_cache

        private

        def clear_cache
          Rails.cache.delete("article_#{id}")
        end
      end
    RUBY
    level: 2
  },
  {
    term: 'prepend_before_action',
    description: 'before_actionのフィルターチェーンの先頭に処理を追加するメソッド。既存のbefore_actionより前に実行させたいときに使う。',
    code_example: <<~'RUBY',
      class ApplicationController < ActionController::Base
        before_action :authenticate_user!

        prepend_before_action :check_maintenance_mode
        # check_maintenance_mode が authenticate_user! より先に実行される

        private

        def check_maintenance_mode
          redirect_to maintenance_path if maintenance_mode?
        end
      end
    RUBY
    level: 2
  },
  {
    term: 'append_before_action',
    description: 'before_actionのフィルターチェーンの末尾に処理を追加するメソッド。before_actionと同じ効果だが、明示的に末尾への追加であることを示したいときに使う。',
    code_example: <<~'RUBY',
      class UsersController < ApplicationController
        append_before_action :set_user, only: [:show]

        private

        def set_user
          @user = User.find(params[:id])
        end
      end
    RUBY
    level: 2
  },
  {
    term: 'skip_after_action',
    description: '親クラスやモジュールで定義されたafter_actionをスキップするメソッド。特定のアクションで後処理を行いたくないときに使う。',
    code_example: <<~'RUBY',
      class ReportsController < ApplicationController
        skip_after_action :log_action, only: [:download]
      end
    RUBY
    level: 2
  },
  {
    term: 'skip_around_action',
    description: '親クラスやモジュールで定義されたaround_actionをスキップするメソッド。',
    code_example: <<~'RUBY',
      class ApiController < ApplicationController
        skip_around_action :measure_time
      end
    RUBY
    level: 2
  },
  {
    term: 'append_after_action',
    description: 'after_actionのフィルターチェーンの末尾に処理を追加するメソッド。after_actionと同じ効果。',
    code_example: <<~'RUBY',
      class ApplicationController < ActionController::Base
        append_after_action :notify_completion

        private

        def notify_completion
          logger.debug "レスポンスの送信完了"
        end
      end
    RUBY
    level: 2
  },

  # ===== Level 3 =====
  {
    term: 'prepend_after_action',
    description: 'after_actionのフィルターチェーンの先頭に処理を追加するメソッド。既存のafter_actionより先に実行させたいときに使う。',
    code_example: <<~'RUBY',
      class ApplicationController < ActionController::Base
        after_action :log_action

        prepend_after_action :set_headers
        # set_headers が log_action より先に実行される
      end
    RUBY
    level: 3
  },
  {
    term: 'prepend_around_action',
    description: 'around_actionのフィルターチェーンの先頭に処理を追加するメソッド。既存のaround_actionより外側で囲んで実行させたいときに使う。',
    code_example: <<~'RUBY',
      class ApplicationController < ActionController::Base
        around_action :inner_wrap

        prepend_around_action :outer_wrap
        # outer_wrap が inner_wrap の外側で実行される
      end
    RUBY
    level: 3
  },
  {
    term: 'append_around_action',
    description: 'around_actionのフィルターチェーンの末尾に処理を追加するメソッド。既存のaround_actionより内側で囲んで実行させたいときに使う。',
    code_example: <<~'RUBY',
      class ApplicationController < ActionController::Base
        around_action :outer_wrap

        append_around_action :inner_wrap
        # outer_wrap が inner_wrap の外側で実行される
      end
    RUBY
    level: 3
  },
  {
    term: 'define_model_callbacks',
    description: 'モデルにカスタムコールバックを定義するクラスメソッド。before_・after_・around_が自動で生成される。ActiveModel::Callbacksをincludeして使う。',
    code_example: <<~'RUBY',
      class Order < ApplicationRecord
        extend ActiveModel::Callbacks
        define_model_callbacks :ship

        before_ship :notify_user

        def ship!
          run_callbacks(:ship) do
            update!(status: "shipped")
          end
        end

        private

        def notify_user
          UserMailer.shipped(self).deliver_later
        end
      end
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
