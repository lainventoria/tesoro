Cp::Application.routes.draw do
  resources :third_parties

  root 'obras#index'

  resources :cuentas
  resources :cajas
  resources :obras
end
