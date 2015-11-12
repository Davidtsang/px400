Rails.application.routes.draw do

  get 'messages/index'

  get 'messages/show'

  resources :comments do
    member do
      post "like"
      post "unlike"
    end

  end

  get 'designers/all'
  get "designers/show/:id" => "designers#show"
  #get "designers/current_user_favorite_folders"

  resources :messages

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

  resources :works do


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
      post "repost"


    end
  end

  get 'static_pages/home'

  get 'static_pages/about'


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  devise_for :users, controllers: {
                       registrations: 'users/registrations'

                   } do

  end

  get "users/:id/following" => "designers#following", as: "following_user"
  get "users/:id/followers" => "designers#followers", as: "followers_user"


  get "designers" => "designers#all"
  devise_scope :user do
    get "profile" => "users/registrations#profile"
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
