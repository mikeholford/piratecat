class BotController < ApplicationController
  def webhook
   if params['hub.verify_token'] == "pirate_cat_verify"
     render text: params['hub.challenge'] and return
   else
     render text: 'error' and return
   end
  end

  def receive_messages
    Rails.logger.debug params.inspect
  end
end
