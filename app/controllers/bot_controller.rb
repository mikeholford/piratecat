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
            'start' => 'welcome_trigger',
            'joke' => 'joke_trigger',
            'meow' => 'joke_trigger',
            'help' => 'help_trigger',
            'receipt' => 'receipt_trigger',
            'products' => 'top_three_shirts'
          }

          quick_responses = {
            'haha' => '😂😂😂',
            'lol' => '😂😂😂',
            'yo' => 'hey how are you?',
            'hi' => 'hey how are you?',
            'hey' => 'hey how are you?',
            'good' => 'that is great!',
            'thanks' => 'no problem',
            'thanks!' => 'no problem',
            'i love you' => 'i love you too'
          }

          trigger_match = false

          quick_responses.each do |qr, text_response|
            if text.include?(qr)
              plain_text(sender, text_response)
              trigger_match = true
            end
          end

          triggers.each do |trig, trig_method|
            if text.include?(trig)
              puts "TEXT includes #{trig}"
              send(trig_method, sender, text)
              trigger_match = true
              break
            end
          end

          if trigger_match == false
            plain_text(sender, "😕 Hmmm... Not sure what you mean? Ask me for help if you need some guidance 👊")
            generic_trigger(sender, text)
            puts "NO MATCH"
          end

          puts "CHECK1"

        end

        if (payload = event[:postback] && event[:postback][:payload])
          puts "PAYLOAD IS: #{payload}"
          puts "PAYLOAD DOWNCASE IS: #{payload.downcase}"
          plain_text(sender, "Hold tight...")
          send(payload, sender, text)
        # else
          # plain_text(sender, "Hmmm..Awkward. Not sure what you mean. Try typing 'HELP' so I can give you a list of things you can chat about.")
        end

      end
    end
    puts "CHECK2"
    render nothing: true

  end

  def welcome_trigger(sender, text)
    pa_token = "EAAYvrTcIpJMBAKnpuuMF1tZC71AytZBZAzkNGRJbd5ETlBRFtDWvROaXwwAJPZAZBXUBrYMTY0qIKulZBWRYRAnoMXiAd03kJajbsbaXU9jHFP5GzG5ScGDwRwTDYvFoInR4iwZBmNzaThmiogvPjIctrs9MJMN0M7ps8YIolJL2wZDZD"

    body = {
      recipient: {
        id: sender
      },
      message: {
        attachment:{
          type: "template",
          payload: {
            template_type: "button",
            text: "👋 Hello!\n\nWelcome to the Pirate Cat Shop! Select an option below to get started. Or type MEOW 🐱 to hear a funny cat joke.",
            buttons: [
              {
                type: "postback",
                title: "View Top 3 T-shirts",
                payload: "top_three_shirts"
              },
              {
                type: "postback",
                title: "Tell me a cat joke",
                payload: "joke_trigger"
              },
              {
                type: "postback",
                title: "Show me what to type",
                payload: "help_trigger"
              }
            ]
          }
        }
      }
    }.to_json
    response = HTTParty.post(
      "https://graph.facebook.com/v2.6/me/messages?access_token=#{pa_token}",
      body: body,
      headers: { 'Content-Type' => 'application/json' }
    )
  end

  def generic_trigger(sender, text)
    pa_token = "EAAYvrTcIpJMBAKnpuuMF1tZC71AytZBZAzkNGRJbd5ETlBRFtDWvROaXwwAJPZAZBXUBrYMTY0qIKulZBWRYRAnoMXiAd03kJajbsbaXU9jHFP5GzG5ScGDwRwTDYvFoInR4iwZBmNzaThmiogvPjIctrs9MJMN0M7ps8YIolJL2wZDZD"

    body = {
      recipient: {
        id: sender
      },
      message: {
        attachment:{
          type: "template",
          payload: {
            template_type: "button",
            text: "Try some options below 👇👇👇",
            buttons: [
              {
                type: "postback",
                title: "View Top 3 T-shirts",
                payload: "top_three_shirts"
              },
              {
                type: "postback",
                title: "Tell me a cat joke",
                payload: "joke_trigger"
              },
              {
                type: "postback",
                title: "Show me what to type",
                payload: "help_trigger"
              }
            ]
          }
        }
      }
    }.to_json
    response = HTTParty.post(
      "https://graph.facebook.com/v2.6/me/messages?access_token=#{pa_token}",
      body: body,
      headers: { 'Content-Type' => 'application/json' }
    )
  end

  def plain_text(sender, text)
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
    pa_token = "EAAYvrTcIpJMBAKnpuuMF1tZC71AytZBZAzkNGRJbd5ETlBRFtDWvROaXwwAJPZAZBXUBrYMTY0qIKulZBWRYRAnoMXiAd03kJajbsbaXU9jHFP5GzG5ScGDwRwTDYvFoInR4iwZBmNzaThmiogvPjIctrs9MJMN0M7ps8YIolJL2wZDZD"

    jokes = [
      "What is it called when a cat wins a dog show? - A CAT_HAS_TROPHY!",
      "Did you hear about the cat who drank 5 bowls of water? He set a new lap record.",
      "What happened when the cat went to the flea circus? He stole the whole show!",
      "Why don't cats play poker in the jungle? Too many cheetahs.",
      "What do you call a cat that has swallowed a duck? A duck filled fatty puss.",
      "How does the cat get its own way? With friendly purrsuasion.",
      "What is a cat's favourite car? The Catillac.",
      "Why did the judge dismiss the entire jury made up of cats? Because each of them was guilty of purrjury.",
      "Why is it so hard for a leopard to hide? Because he's always spotted.",
      "What kind of cat will keep your grass short? A Lawn Meower."
    ]

    body = {
      recipient: {
        id: sender
      },
      message: {
        text: jokes.sample + "😂😂😂"
      }
    }.to_json
    response = HTTParty.post(
      "https://graph.facebook.com/v2.6/me/messages?access_token=#{pa_token}",
      body: body,
      headers: { 'Content-Type' => 'application/json' }
    )
  end

  def help_trigger(sender, text)
    pa_token = "EAAYvrTcIpJMBAKnpuuMF1tZC71AytZBZAzkNGRJbd5ETlBRFtDWvROaXwwAJPZAZBXUBrYMTY0qIKulZBWRYRAnoMXiAd03kJajbsbaXU9jHFP5GzG5ScGDwRwTDYvFoInR4iwZBmNzaThmiogvPjIctrs9MJMN0M7ps8YIolJL2wZDZD"

   body = {
    recipient: {
      id: sender
    },
    message: {
      text: "Need some help? Here are some options.\n\n • MEOW / JOKE for a cat joke \n • RECEIPT for a receipt of your last purchase \n • PRODUCTS for the top 3 tshirts in our shop \n • START to begin again."
    }
    }.to_json
    response = HTTParty.post(
      "https://graph.facebook.com/v2.6/me/messages?access_token=#{pa_token}",
      body: body,
      headers: { 'Content-Type' => 'application/json' }
    )
  end

  def receipt_trigger(sender, text)

    plain_text(sender, "Fetching your recent purchase...")

    pa_token = "EAAYvrTcIpJMBAKnpuuMF1tZC71AytZBZAzkNGRJbd5ETlBRFtDWvROaXwwAJPZAZBXUBrYMTY0qIKulZBWRYRAnoMXiAd03kJajbsbaXU9jHFP5GzG5ScGDwRwTDYvFoInR4iwZBmNzaThmiogvPjIctrs9MJMN0M7ps8YIolJL2wZDZD"

    body = {
      recipient: {
        id: sender
      },
      message:{
        attachment:{
          type: "template",
          payload:{
            template_type: "receipt",
            recipient_name: "Stephane Crozatier",
            order_number: "#{Random.rand(76585467897596095786)}",
            currency: "USD",
            payment_method: "Visa 2345",
            order_url: "http://petersapparel.parseapp.com/order?order_id=123456",
            timestamp: "1428444852",
            elements:[
              {
                title: "Classic White T-Shirt",
                subtitle: "100% Soft and Luxurious Cotton",
                quantity: 2,
                price: 50,
                currency: "USD",
                image_url: "http://petersapparel.parseapp.com/img/whiteshirt.png"
              },
              {
                title: "Classic Gray T-Shirt",
                subtitle: "100% Soft and Luxurious Cotton",
                quantity: 1,
                price: 25,
                currency: "USD",
                image_url: "http://petersapparel.parseapp.com/img/grayshirt.png"
              }
            ],
            address:{
              street_1: "1 Hacker Way",
              street_2: "",
              city: "Menlo Park",
              postal_code: "94025",
              state: "CA",
              country: "US"
            },
            summary:{
              subtotal: 75.00,
              shipping_cost: 4.95,
              total_tax: 6.19,
              total_cost: 56.14
            },
            adjustments:[
              {
                name: "New Customer Discount",
                amount: 20
              },
              {
                name: "$10 Off Coupon",
                amount: 10
              }
            ]
          }
        }
      }
    }.to_json
    response = HTTParty.post(
      "https://graph.facebook.com/v2.6/me/messages?access_token=#{pa_token}",
      body: body,
      headers: { 'Content-Type' => 'application/json' }
    )
  end



  def top_three_shirts(sender, text)
     plain_text(sender, "Sure! Just fetching the our top 3 sellers at the moment...")


     pa_token = "EAAYvrTcIpJMBAKnpuuMF1tZC71AytZBZAzkNGRJbd5ETlBRFtDWvROaXwwAJPZAZBXUBrYMTY0qIKulZBWRYRAnoMXiAd03kJajbsbaXU9jHFP5GzG5ScGDwRwTDYvFoInR4iwZBmNzaThmiogvPjIctrs9MJMN0M7ps8YIolJL2wZDZD"

    body = {
      recipient: {
        id: sender
      },
      message: {
        attachment:{
          type: "template",
          payload: {
            template_type: "generic",
            elements: [
              {
                title: "Checked Pirate Shirt",
                image_url: "http://petersapparel.parseapp.com/img/item100-thumb.png",
                subtitle: "Soft white cotton t-shirt is back in style",
                buttons: [
                  {
                    type: "web_url",
                    url: "https://petersapparel.parseapp.com/view_item?item_id=100",
                    title: "View Item"
                  },
                  {
                    type: "web_url",
                    url: "https://petersapparel.parseapp.com/buy_item?item_id=100",
                    title: "Buy Item"
                  },
                  {
                    type: "postback",
                    title: "Bookmark Item",
                    payload: "bookmark_trigger"
                  }
                ]
              },
              {
                title: "Funky Cat Shirt",
                image_url: "http://petersapparel.parseapp.com/img/item101-thumb.png",
                subtitle: "Soft white cotton t-shirt is back in style",
                buttons: [
                  {
                    type: "web_url",
                    url: "https://petersapparel.parseapp.com/view_item?item_id=101",
                    title: "View Item"
                  },
                  {
                    type: "web_url",
                    url: "https://petersapparel.parseapp.com/buy_item?item_id=101",
                    title: "Buy Item"
                  },
                  {
                    type: "postback",
                    title: "Bookmark Item",
                    payload: "bookmark_trigger"
                  }
                ]
              },
              {
                title: "Crazy Cat Lady Shirt",
                image_url: "http://petersapparel.parseapp.com/img/item100-thumb.png",
                subtitle: "Soft white cotton t-shirt is back in style",
                buttons: [
                  {
                    type: "web_url",
                    url: "https://petersapparel.parseapp.com/view_item?item_id=100",
                    title: "View Item"
                  },
                  {
                    type: "web_url",
                    url: "https://petersapparel.parseapp.com/buy_item?item_id=100",
                    title: "Buy Item"
                  },
                  {
                    type: "postback",
                    title: "Bookmark Item",
                    payload: "bookmark_trigger"
                  }
                ]
              }
            ]
          }
        }
      }
    }.to_json
    response = HTTParty.post(
      "https://graph.facebook.com/v2.6/me/messages?access_token=#{pa_token}",
      body: body,
      headers: { 'Content-Type' => 'application/json' }
    )
  end

  def bookmark_trigger(sender, text)
    pa_token = "EAAYvrTcIpJMBAKnpuuMF1tZC71AytZBZAzkNGRJbd5ETlBRFtDWvROaXwwAJPZAZBXUBrYMTY0qIKulZBWRYRAnoMXiAd03kJajbsbaXU9jHFP5GzG5ScGDwRwTDYvFoInR4iwZBmNzaThmiogvPjIctrs9MJMN0M7ps8YIolJL2wZDZD"

    body = {
      recipient: {
        id: sender
      },
      message: {
        text: "Saved to your favourites! 🌟🌟🌟"
      }
    }.to_json
    response = HTTParty.post(
      "https://graph.facebook.com/v2.6/me/messages?access_token=#{pa_token}",
      body: body,
      headers: { 'Content-Type' => 'application/json' }
    )
  end

end
