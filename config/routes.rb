Rails.application.routes.draw do

  resources :games
  # cross domain error
  match '*any' => 'application#options', :via => [:options]

end