Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'dashboard#index'

  mount Resque::Server.new, at: '/resque'
  mount ResqueWeb::Engine => '/resque_web'
end
