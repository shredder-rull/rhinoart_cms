Rails.application.routes.draw do
  devise_for :users
  mount Rhinoart::Engine, at: "/"
  root 'pages#index'
  match '*url' => 'pages#internal', :as => :page, via: [:get]
end
