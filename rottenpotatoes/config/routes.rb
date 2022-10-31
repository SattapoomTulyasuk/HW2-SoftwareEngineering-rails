Rottenpotatoes::Application.routes.draw do
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  post '/logout', to: 'sessions#destroy'

  get '/auth/google_oauth2/callback', to: 'sessions#omniauth'

  resources :users, :movies
  # map '/' to be a redirect to '/movies'
  root :to => 'application#welcome'

  post '/movies/search_tmdb' => 'movies#search_tmdb', :as => 'search_tmdb'
end
