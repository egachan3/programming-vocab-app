# Rails - アクションケーブルに関する用語のシードデータ

category = Category.find_or_create_by!(name: 'アクションケーブル', large_category: @rails_category)

words = [
  # ===== Level 1 =====
  {
    term: 'action_cable_meta_tag',
    description: 'Action CableのWebSocket接続URLをmetaタグとして出力するビューヘルパー。レイアウトの<head>内に記述することでJavaScript側がWebSocketのエンドポイントを自動で取得できる。',
    code_example: <<~'ERB',
      <%# layouts/application.html.erb の <head> 内 %>
      <%= action_cable_meta_tag %>
      <%# => <meta name="action-cable-url" content="/cable"> %>
    ERB
    level: 1
  },
  {
    term: 'broadcast_to',
    description: '特定のストリームに対してデータをブロードキャスト（送信）するクラスメソッド。購読しているすべてのクライアントにリアルタイムでデータを届ける。',
    code_example: <<~'RUBY',
      # コントローラーやモデルから呼び出す
      ChatChannel.broadcast_to(
        @room,
        { message: "こんにちは", user: current_user.name }
      )

      # ジョブから呼び出す例
      ActionCable.server.broadcast(
        "chat_#{room.id}",
        { message: content }
      )
    RUBY
    level: 1
  },
  {
    term: 'subscribed',
    description: 'クライアントがチャンネルを購読したときに呼ばれるコールバックメソッド。ストリームへの接続処理をここに書く。',
    code_example: <<~'RUBY',
      class ChatChannel < ApplicationCable::Channel
        def subscribed
          room = Room.find(params[:room_id])
          stream_for room
          # または
          stream_from "chat_#{params[:room_id]}"
        end
      end
    RUBY
    level: 1
  },
  {
    term: 'unsubscribed',
    description: 'クライアントがチャンネルの購読を解除したときに呼ばれるコールバックメソッド。接続解除時のクリーンアップ処理をここに書く。',
    code_example: <<~'RUBY',
      class ChatChannel < ApplicationCable::Channel
        def subscribed
          stream_for @room
          @room.users_online.add(current_user)
        end

        def unsubscribed
          @room.users_online.remove(current_user)
        end
      end
    RUBY
    level: 1
  },
  {
    term: 'transmit',
    description: '購読している特定のクライアントにデータを送信するインスタンスメソッド。broadcast_toと異なり同じストリームの全クライアントではなく、そのコネクションのみに送る。',
    code_example: <<~'RUBY',
      class NotificationChannel < ApplicationCable::Channel
        def subscribed
          stream_for current_user
        end

        def receive(data)
          # クライアントから受け取ったデータを処理して返す
          transmit({ status: "received", data: data })
        end
      end
    RUBY
    level: 1
  },

  # ===== Level 2 =====
  {
    term: 'broadcasting_for',
    description: 'モデルオブジェクトからブロードキャスト用のストリーム名を生成するクラスメソッド。broadcast_toが内部で使用しているストリーム名を確認するときに使う。',
    code_example: <<~'RUBY',
      room = Room.find(1)
      ChatChannel.broadcasting_for(room)
      # => "chat_channel:Z2lkOi8vYXBwL1Jvb20vMQ"

      # テストでストリーム名を確認する場合
      assert_broadcast_on(
        ChatChannel.broadcasting_for(@room),
        message: "こんにちは"
      )
    RUBY
    level: 2
  },
  {
    term: 'reject',
    description: 'クライアントのチャンネル購読を拒否するメソッド。subscribedコールバック内で認証チェックを行い、権限がない場合に呼び出す。',
    code_example: <<~'RUBY',
      class AdminChannel < ApplicationCable::Channel
        def subscribed
          reject unless current_user.admin?
          stream_from "admin_notifications"
        end
      end
    RUBY
    level: 2
  },
  {
    term: 'subscription_rejected?',
    description: '購読が拒否されたかどうかを確認するメソッド。rejectが呼ばれた後にtrueを返す。',
    code_example: <<~'RUBY',
      class AdminChannel < ApplicationCable::Channel
        def subscribed
          reject unless current_user.admin?
        end

        def receive(data)
          return if subscription_rejected?
          # 拒否されていない場合の処理
        end
      end
    RUBY
    level: 2
  },
  {
    term: 'perform_action',
    description: 'クライアントから送信されたアクション名とデータに基づいてチャンネルのメソッドを実行するメソッド。通常はフレームワークが自動で呼び出す。',
    code_example: <<~'RUBY',
      class ChatChannel < ApplicationCable::Channel
        def subscribed
          stream_for @room
        end

        # クライアントから { "action": "send_message", "content": "Hello" }
        # が送られるとこのメソッドが呼ばれる
        def send_message(data)
          @room.messages.create!(content: data["content"], user: current_user)
        end
      end
    RUBY
    level: 2
  },

  # ===== Level 3 =====
  {
    term: 'ensure_confirmation_sent',
    description: '購読確認をクライアントに必ず送信するメソッド。defer_subscription_confirmation!で遅延させた確認を強制的に送信したいときに使う。',
    code_example: <<~'RUBY',
      class ChatChannel < ApplicationCable::Channel
        def subscribed
          defer_subscription_confirmation!
          # 非同期で何かを確認
          room = Room.find(params[:room_id])
          if room.accessible_by?(current_user)
            stream_for room
            ensure_confirmation_sent
          else
            reject
          end
        end
      end
    RUBY
    level: 3
  },
  {
    term: 'defer_subscription_confirmation!',
    description: '購読確認の送信を遅らせるメソッド。subscribedコールバック内で非同期処理が完了するまで確認を保留したいときに使う。',
    code_example: <<~'RUBY',
      class DataChannel < ApplicationCable::Channel
        def subscribed
          defer_subscription_confirmation!
          # 非同期で認証処理を行い、完了後に ensure_confirmation_sent を呼ぶ
          ValidateConnectionJob.perform_later(self)
        end
      end
    RUBY
    level: 3
  },
  {
    term: 'action_methods',
    description: 'チャンネルクラスで定義されているアクションメソッド（クライアントから呼び出せるメソッド）の一覧をSetで返すクラスメソッド。',
    code_example: <<~'RUBY',
      class ChatChannel < ApplicationCable::Channel
        def subscribed;   end
        def unsubscribed; end
        def send_message(data); end
        def typing; end
      end

      ChatChannel.action_methods
      # => #<Set: {"send_message", "typing"}>
      # subscribed と unsubscribed はコールバックのため除外される
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
