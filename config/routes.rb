Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  resources :children do
    resources :daily_reports
  end

  root 'children#home'
  get '/home' => 'children#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
