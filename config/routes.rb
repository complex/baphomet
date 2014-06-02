Rails.application.routes.draw do

  root to: 'payments#new'

  resources :payments

end
