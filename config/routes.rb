Rails.application.routes.draw do

  get 'bot/webhook'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'statics#landing'

  # match '/webhooks', to: 'statics#webhooks', as: :webhooks, via: :get

  mount Messenger::Bot::Space => "/webhook"

end
