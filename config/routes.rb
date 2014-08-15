Rails.application.routes.draw do
  root to: 'application#index'
  get 'users/:id' => 'users#show', as: 'board'
  post 'users/:id/play' => 'users#play', as: 'play'
end
