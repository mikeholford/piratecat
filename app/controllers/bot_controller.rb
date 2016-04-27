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
          if text.to_s.downcase.include? "pictures"
            links = {
              "Me as a pirate" => "https://suddenlycat.com/wp-content/uploads/2015/03/Pirate-Cat-Costume1.jpg",
              "Me as a moo cow" => "http://cf.ltkcdn.net/wp-content/uploads/2014/10/cow-cat-300x199.jpg",
              "Me as a frog" => "http://cf.ltkcdn.net/wp-content/uploads/2014/10/frog-cat1-294x300.jpg",
            }
            send_links(sender, links)
          else
            repeat_text(sender, "You said: #{text}")
          end
         end
       end
     end
     render nothing: true

  end




  def repeat_text(sender, text)
    page_access_token = "CAAYvrTcIpJMBANAxFVGKOMPyIlOIIZB6GydpspBRuPLV1PqNqwTeDyhLCaPqkCgfqMi5Pk38bnoIS8ZC1ytRTckFW8QMlAUcjvza1q1tFAev7SisDL99STpvfi72cj6iVJlEZC8QAlMCmc7ZARn3ZBkEFZAuDWUQQUpexqtu9A2Mi6K2NMKPBlia7AMQbUmkbNFnPp9wtrrwZDZD"

    body = {
      recipient: {
        id: sender
      },
      message: {
        text: text
      }
    }.to_json
    response = HTTParty.post(
      "https://graph.facebook.com/v2.6/me/messages?access_token=#{page_access_token}",
      body: body,
      headers: { 'Content-Type' => 'application/json' }
    )
  end



  def send_links(sender, links)
    page_access_token = "CAAYvrTcIpJMBANAxFVGKOMPyIlOIIZB6GydpspBRuPLV1PqNqwTeDyhLCaPqkCgfqMi5Pk38bnoIS8ZC1ytRTckFW8QMlAUcjvza1q1tFAev7SisDL99STpvfi72cj6iVJlEZC8QAlMCmc7ZARn3ZBkEFZAuDWUQQUpexqtu9A2Mi6K2NMKPBlia7AMQbUmkbNFnPp9wtrrwZDZD"

    body = {
      recipient: {
        id: sender
      },
      message: {
        attachment:{
          type: "template",
          payload: {
            template_type: "button",
            text: "What picture would you like to see?",
            buttons: [
              links.each do |title, url|
                {
                  type: "web_url",
                  url: "#{url}",
                  title: "#{title}"
                },
              end
            ]
          }
        }
      }
    }.to_json
    response = HTTParty.post(
      "https://graph.facebook.com/v2.6/me/messages?access_token=#{page_access_token}",
      body: body,
      headers: { 'Content-Type' => 'application/json' }
    )
  end

end
