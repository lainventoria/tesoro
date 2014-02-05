Cp::Application.routes.draw do
  root 'obras#index'

  resources :obras do
    resources :cajas
  end

  resources :cuentas

  # Filtrar facturas por situacion
  get "facturas/cobros", to: "facturas#cobros"
  get "facturas/pagos", to: "facturas#pagos"

  resources :facturas do
    resources :recibos
  end

  resources :terceros
end
