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


    puts "Message recieved"
    Rails.logger.debug params.inspect

     if params[:entry]
       messaging_events = params[:entry][0][:messaging]
         messaging_events.each do |event|
         sender = event[:sender][:id]
         if (text = event[:message] && event[:message][:text])
           send_text_message(sender, "MEOW! You said: #{text}. Love Pirate Cat")
         end
       end
     end
     render nothing: true

  end




  def send_text_message(sender, text)
    page_access_token = "CAAYvrTcIpJMBANAxFVGKOMPyIlOIIZB6GydpspBRuPLV1PqNqwTeDyhLCaPqkCgfqMi5Pk38bnoIS8ZC1ytRTckFW8QMlAUcjvza1q1tFAev7SisDL99STpvfi72cj6iVJlEZC8QAlMCmc7ZARn3ZBkEFZAuDWUQQUpexqtu9A2Mi6K2NMKPBlia7AMQbUmkbNFnPp9wtrrwZDZD"

    body = {
      recipient: {
        id: sender
      },
      # message: {
      #   text: text
      # }
      message: repeat_response
    }.to_json
    response = HTTParty.post(
      "https://graph.facebook.com/v2.6/me/messages?access_token=#{page_access_token}",
      body: body,
      headers: { 'Content-Type' => 'application/json' }
    )
  end

  def repeat_response
    @response = {
      text: text
    }
    return @response
  end

  def picture_response
    message: {
      attachment:{
        type: "template",
        payload: {
          template_type: "button",
          text: "What picture would you like to see?",
          buttons: [
            {
              type: "web_url",
              url: "https://suddenlycat.com/wp-content/uploads/2015/03/Pirate-Cat-Costume1.jpg",
              title: "Me as a pirate"
            },
            {
              type: "web_url",
              url: "http://cf.ltkcdn.net/wp-content/uploads/2014/10/cow-cat-300x199.jpg",
              title: "Me as a cow"
            }
          ]
        }
      }
    }
  end

end
