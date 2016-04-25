class BotController < ApplicationController

  skip_before_action :verify_authenticity_token

  def webhook
    Rails.logger.debug "Webhook working bitches!"
   if params['hub.verify_token'] == "pirate_cat_verify"
     render text: params['hub.challenge'] and return
   else
     render text: 'error' and return
   end
  end

  def receive_message
    Rails.logger.debug params.inspect
    puts "HAHA THIS IS ACTUALLY WORKING"
    Rails.logger.debug "TESTING 123piratecat"
  end
end
