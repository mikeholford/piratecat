Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'statics#landing'

  # mount Messenger::Bot::Space => "/webhook"

  get 'bot/webhook' => 'bot#webhook'
  post 'bot/webhook' => 'bot#receive_message'



end
