Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "searches#show"

  resource :search, only: [:show] do
    collection do
      get :autocomplete
    end
  end
end
