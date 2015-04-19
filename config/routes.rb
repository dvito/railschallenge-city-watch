Rails.application.routes.draw do
  
  resources :responders,
            only: [:index, :create, :update, :show],
            defaults: { format: :json }
  resources :emergencies,
            only: [:index, :create, :update, :show],
            defaults: { format: :json }

end
