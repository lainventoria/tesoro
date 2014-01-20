Cp::Application.routes.draw do
  root 'obras#index'

  resources :cuentas
  resources :cajas
  resources :obras
  resources :recibos
  resources :facturas
  resources :terceros
end
