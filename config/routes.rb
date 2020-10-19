Spree::Core::Engine.add_routes do
  # Add your extension routes here
  namespace :admin, path: Spree.admin_path do
    resources :deliveries, only: %i[index show new create destroy] do
      member do
        get :start
        get :finish
      end
    end
  end
end
