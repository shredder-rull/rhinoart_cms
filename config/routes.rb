Rhinoart::Engine.routes.draw do

  devise_scope :user do
    get 'sign_in' => 'sessions#new'
    post 'sign_in' => 'sessions#create'
    get 'sign_out' => 'sessions#destroy'
  end

  scope "(:locale)", locale: /ru|en/ do

    resources :users

    root :to => 'dashboard#index'

    # Pages
    resources :pages do
      member do
        get 'showhide'
        get 'children'
        get 'hide_children'
        get 'new', as: :new_children
      end
      get 'tree', on: :collection
      get 'field_page_add', on: :collection

      get 'up'
      get 'down'
    end

    # Page structures
    resources :structures, only: [:index]

    resources :page_comments
    resources :page_fields, only: [:new, :create, :destroy], via: :js

    resources :settings
    resources :dashboard

    #upload files
    scope :fileworks do
      match 'upload_image' => 'fileworks#upload_image', via: [:get, :post]#, via: :js
      match 'upload_file' => 'fileworks#upload_file' , via: [:get, :post]
      match 'image_list' => 'fileworks#image_list', via: [:get]
    end

    get 'caches/clear' => 'caches#clear'

  end
end

