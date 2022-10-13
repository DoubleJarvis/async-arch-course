class AccountsStreamConsumer < ApplicationConsumer
  def consume
    messages.each do |message| 
      # binding.pry
      process(message.payload)
    end
  end

  private 

  def process(message)
    case message['event_name']
    when 'AccountCreated'
      Account.create(message['data'].merge(provider: 'popug_auth'))
    when 'AccountUpdated'
      Account.find_by(public_id: message.dig('data', 'public_id'))&.update(message['data'])
    when 'AccountDeleted'
      Account.find_by(public_id: message.dig('data', 'public_id'))&.destroy
    else
      puts "Unknown event #{message['event_name']}"
    end
  end
end
