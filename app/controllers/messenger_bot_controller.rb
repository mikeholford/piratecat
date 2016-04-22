class MessengerBotController < ApplicationController

  def message(event, sender)
    # profile = sender.get_profile
    sender.reply({ text: "Reply: #{event['message']['text']}" })
  end

  def delivery(event, sender)
    sender.reply({ text: "Reply: #{event['message']['text']}" })
    #BlahBlah
  end

  def postback(event, sender)
    sender.reply({ text: "Reply: #{event['message']['text']}" })
    #BlahBlah
  end

end
