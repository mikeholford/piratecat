class BotController < ApplicationController

  skip_before_action :verify_authenticity_token

  def webhook
   if params['hub.verify_token'] == "pirate_cat_verify"
     render text: params['hub.challenge'] and return
   else
     render text: 'error' and return
   end
  end

  def receive_message
   if params[:entry]
     messaging_events = params[:entry][0][:messaging]
       messaging_events.each do |event|
       sender = event[:sender][:id]
       if (text = event[:message] && event[:message][:text])
         # send_text_message(sender, "Hi there! You said: #{text}. The Bots")
       end
     end
   end
   render nothing: true
  end
end
