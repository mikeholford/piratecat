Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'statics#landing'

  get '/webhook' => 'messenger_bot#webhook'
  post '/webhook' => 'messenger_bot#receive_message'


  # mount Messenger::Bot::Space => "/webhook"



end
