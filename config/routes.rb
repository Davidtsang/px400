Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  resources :icodes
  get 'reports/index'

  post 'reports/create'


  resources :comments do
    member do
      post "like"
      post "unlike"
      post "remove"
    end

  end

  get 'designers/all'
  get "designers/:id" => "designers#show"
  #get "designers/current_user_favorite_folders"
  post "block_user" => "designers#block_user"
  post "unblock_user" => "designers#unblock_user"

  resources :messages do
    collection do
      get 'sent'
      post 'disable_show/:id' =>"messages#disable_show"
      get "show_sent/:id" => "messages#show_sent"
    end
  end

  resources :notifications do
    member do
      post "mark_checked"
    end
  end

  post "labels" => "tags#create_label"

  resources :tags do
    collection do
      get "suggest"
      post "remove_skill_tag/:id" => "tags#remove_skill_tag"
      post "remove_work_tag/:id" => "tags#remove_work_tag"
    end
  end
  resources :favorite_folders do
    post "create_favorite"

  end

  post "delete_favorite/:id" => "favorite_folders#delete_favorite", as: "delete_favorite"

  get "explore" => "works#explore"

  resources :works ,except: :index do

    collection do
      get 'feed' => "works#feed"
    end

    member do
      #ajax like
      post "works_like" => "works#like"
      #ajax unlike
      post "works_unlike" => "works#unlike"

      #ajax like
      post "thank" => "works#thank"
      #ajax unlike
      post "unthank" => "works#unthank"

      #ajax repost
      get "new_repost" =>"works#new_repost"

      post "repost"

      get "edit_tags"

      get "likes" => "works#likes"

      get "favorites" => "works#favorites"

      get "reworks" => "works#reworks"


    end
  end

  get 'home' =>"static_pages#home", as: "static_pages_home"

  get 'static_pages/about'

  get 'about_icode' => "static_pages#about_icode"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  devise_for :users, controllers: {
                       registrations: 'users/registrations'

                   } do

  end

  get "users/:id/following" => "designers#following", as: "following_user"
  get "users/:id/followers" => "designers#followers", as: "followers_user"
  get "/designers/:id/tags/:tag_id" => "designers#show_tag"

  get "designers" => "designers#all"
  devise_scope :user do

    get '/sign_up' => "users/registrations#new"

    get "block_list" => "users/registrations#block_list"
    get "profile" => "users/registrations#profile"


    get "users/:id/icodes" => "users/registrations#icodes", as: "users_icodes"

    put "update_profile" => "users/registrations#update_profile"
    put "update_avatar" => "users/registrations#update_avatar"

  end


  resources :relationships, only: [:create, :destroy]

  # You can have the root of your site routed with "root"
  root 'static_pages#home'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
