Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  devise_for :admins
  
  resources :devices, :adverts, :ad_lists
  
get "/contact", to: "static#contact"
get "/test", to: "static#test"
get "/adunit/:prize/:tag", to: "static#adunit", :as => "adunit"
get "/coupons/:tag", to: "static#coupons", :as => "coupons"
get "/devices", to: "devices#index"
get "/adverts", to: "adverts#index"
get "/ad_lists", to: "ad_lists#index"


get "/api/getads/:tag/:lastid", to: "api#getads"
get "/api/clearads/:tag", to: "api#clearads"
get "/api/exclude/:tag/:advert_id", to: "api#exclude"
get "/api/keep/:tag/:advert_id", to: "api#keep"
get "/api/get_kept_coupons/:tag", to: "api#get_kept_coupons"
get "/api/get_kept_ads/:tag", to: "api#get_kept_ads"
get "/api/get_instruct/:tag", to: "api#get_instruct"
get "/api/set_instruct/:tag/:cnt", to: "api#set_instruct"
get "/api/formupload/", to: "api#formupload"

  # You can have the root of your site routed with "root"
   root 'static#home'

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
