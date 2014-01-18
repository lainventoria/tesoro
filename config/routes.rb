Cp::Application.routes.draw do
  resources :recibos

  resources :facturas

  resources :terceros

  root 'obras#index'

  resources :cuentas
  resources :cajas
  resources :obras
end
