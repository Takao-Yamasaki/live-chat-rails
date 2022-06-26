class RoomChannel < ApplicationCable::Channel
  def subscribed
    # Webブラウザ側のコネクションが確率すると呼び出される
    stream_from "room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    # メッセージ受信のたびに呼び出される
    user = User.find_by(email: data['email'])

    if message = Message.create(content: data['message'], user_id: user.id)
      # room_channelに接続されているWebブラウザ全てにデータを送信
      ActionCable.server.broadcast 'room_channel', { message: data['message'], name: user.name, created_at: message.created_at }
    end
  end
end
