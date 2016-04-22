class MessengerBotController < ApplicationController

  def message(event, sender)
    # profile = sender.get_profile
    sender.reply({ text: "Reply: #{event['message']['text']}" })
    puts 'message message message!!!!!'
  end

  def delivery(event, sender)
    puts 'delivery delivery delivery!!!!!'
    #BlahBlah
  end

  def postback(event, sender)
    puts 'postback postback postback!!!!!'
    #BlahBlah
  end

end
