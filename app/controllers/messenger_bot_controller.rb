class MessengerBotController < ApplicationController

  skip_before_action :verify_authenticity_token

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




  def webhook
   if params['hub.verify_token'] == "pirate_cat_verify"
     render text: params['hub.challenge'] and return
   else
     render text: 'error' and return
   end
  end

  def receive_message
    Rails.logger.debug params.inspect

     if params[:entry]
       messaging_events = params[:entry][0][:messaging]
         messaging_events.each do |event|
         sender = event[:sender][:id]
         if (text = event[:message] && event[:message][:text])
          puts "WOOP Message recieved"
           # send_text_message(sender, “Hi there! You said: #{text}. The Bots”)
         end
       end
     end
     render nothing: true
  end

end
