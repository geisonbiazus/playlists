Rails.application.routes.draw do
  get 'users' => 'users#index'
  post 'users/import' => 'users#import'
  post 'tracks/import' => 'tracks#import'
  post 'playlists/import' => 'playlists#import'
  get 'users/:id/playlists' => 'users#playlists', as: :user_playlists

  root to: 'users#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
