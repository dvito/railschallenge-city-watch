Rails.application.routes.draw do
  resources :responders,
            only: [:index, :create, :update, :show],
            defaults: { format: :json }
  resources :emergencies,
            only: [:index, :create, :update, :show],
            defaults: { format: :json }

  # This is a catchall to handle 404 errors to comply with the test suite
  match '*path', to: 'application#page_not_found', via: :all
end
