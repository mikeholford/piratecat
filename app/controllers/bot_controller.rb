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

        if (text = event[:message] && event[:message][:text]) # User has sent a text response
          # response = event[:message][:text]
          text = text.downcase
          puts "text is now: #{text}"

          triggers = {
            'meow' => 'joke_trigger',
            'help' => 'help_trigger'
          }

          trigger_match = false

          triggers.each do |trig, trig_method|
            if text.include?(trig)
              puts "TEXT includes #{trig}"
              send(trig_method, sender, text)
              trigger_match = true
              break
            end
          end

          if trigger_match == false
            plain_text(sender, "Hmmm..no match. Not sure what you mean. Try typing 'HELP' so I can give you a list of things you can chat about.")
            puts "NO MATCH"
          end

          puts "CHECK1"

        # elsif event[:postback][:payload] # User has sent a payload
        #   plain_text(sender, "Hmmm..payload. Not sure what you mean. Try typing 'HELP' so I can give you a list of things you can chat about.")
        else
          # plain_text(sender, "Hmmm..Awkward. Not sure what you mean. Try typing 'HELP' so I can give you a list of things you can chat about.")
        end

      end
    end
    puts "CHECK2"
    render nothing: true

  end




  def plain_text(sender, text)
    puts "SEND PLAIN"
    pa_token = "EAAYvrTcIpJMBAKnpuuMF1tZC71AytZBZAzkNGRJbd5ETlBRFtDWvROaXwwAJPZAZBXUBrYMTY0qIKulZBWRYRAnoMXiAd03kJajbsbaXU9jHFP5GzG5ScGDwRwTDYvFoInR4iwZBmNzaThmiogvPjIctrs9MJMN0M7ps8YIolJL2wZDZD"

    body = {
      recipient: {
        id: sender
      },
      message: {
        text: text
      }
    }.to_json
    response = HTTParty.post(
      "https://graph.facebook.com/v2.6/me/messages?access_token=#{pa_token}",
      body: body,
      headers: { 'Content-Type' => 'application/json' }
    )
  end




  def joke_trigger(sender, text)
    puts "send JOKE"
    pa_token = "EAAYvrTcIpJMBAKnpuuMF1tZC71AytZBZAzkNGRJbd5ETlBRFtDWvROaXwwAJPZAZBXUBrYMTY0qIKulZBWRYRAnoMXiAd03kJajbsbaXU9jHFP5GzG5ScGDwRwTDYvFoInR4iwZBmNzaThmiogvPjIctrs9MJMN0M7ps8YIolJL2wZDZD"

    jokes = [
      "What is it called when a cat wins a dog show? - A CAT_HAS_TROPHY!",
      "Did you hear about the cat who drank 5 bowls of water? He set a new lap record.",
      "What happened when the cat went to the flea circus? He stole the whole show!",
      "Why don't cats play poker in the jungle? Too many cheetahs."
    ]

    body = {
      recipient: {
        id: sender
      },
      message: {
        text: jokes.sample
      }
    }.to_json
    response = HTTParty.post(
      "https://graph.facebook.com/v2.6/me/messages?access_token=#{pa_token}",
      body: body,
      headers: { 'Content-Type' => 'application/json' }
    )
  end

  def help_trigger(sender, text)
    puts "send HELP"
    pa_token = "EAAYvrTcIpJMBAKnpuuMF1tZC71AytZBZAzkNGRJbd5ETlBRFtDWvROaXwwAJPZAZBXUBrYMTY0qIKulZBWRYRAnoMXiAd03kJajbsbaXU9jHFP5GzG5ScGDwRwTDYvFoInR4iwZBmNzaThmiogvPjIctrs9MJMN0M7ps8YIolJL2wZDZD"

   body = {
    recipient: {
      id: sender
    },
    message: {
      text: "Need some help? Here are some options. Type MEOW for a cat joke, RECEIPT for a receipt of your last purchase, PRODUCTS for the top 3 tshirts in our shop, PICTURE for a fun picture of me and FACT for a fun cat fact!"
    }
    }.to_json
    response = HTTParty.post(
      "https://graph.facebook.com/v2.6/me/messages?access_token=#{pa_token}",
      body: body,
      headers: { 'Content-Type' => 'application/json' }
    )
  end



  def repeat_text(sender, text)

    body = {
      recipient: {
        id: sender
      },
      message: {
        text: text
      }
    }.to_json
    response = HTTParty.post(
      "https://graph.facebook.com/v2.6/me/messages?access_token=#{set_page_access}",
      body: body,
      headers: { 'Content-Type' => 'application/json' }
    )
  end



  def send_links(sender, text)

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
    }.to_json
    response = HTTParty.post(
      "https://graph.facebook.com/v2.6/me/messages?access_token=#{set_page_access}",
      body: body,
      headers: { 'Content-Type' => 'application/json' }
    )
  end

  # def set_page_access
  #   return "EAAYvrTcIpJMBAKnpuuMF1tZC71AytZBZAzkNGRJbd5ETlBRFtDWvROaXwwAJPZAZBXUBrYMTY0qIKulZBWRYRAnoMXiAd03kJajbsbaXU9jHFP5GzG5ScGDwRwTDYvFoInR4iwZBmNzaThmiogvPjIctrs9MJMN0M7ps8YIolJL2wZDZD"
  # end

end
