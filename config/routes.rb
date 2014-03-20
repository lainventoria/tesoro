Cp::Application.routes.draw do
  root 'obras#index'

  # facturas, recibos, cajas y cheques se modifican dentro de una obra,
  # el resto son listados con distintos niveles de generalidad
  resources :obras do

    resources :cajas do
      resources :cheques
    end

    resources :facturas do
    # Filtrar facturas por situacion
      collection do
        get 'cobros'
        get 'pagos'
      end

      # Trabajar los recibos de cada factura
      resources :recibos
    end
  end

  resources :cajas, only: [ :index, :show ] do
    resources :cheques, only: [ :index, :show ]
  end

  # ver las facturas y filtrarlas por situacion
  resources :facturas, only: [ :index, :show ] do
    collection do
      get 'cobros'
      get 'pagos'
    end

    # Permitir ver los /recibos de esta factura
    resources :recibos, only: [ :index, :show ]
  end

  # ver /recibos y filtrarlos por situacion
  resources :recibos, only: [ :index, :show ] do
    collection do
      get 'cobros'
      get 'pagos'
    end
  end

  # los terceros se crean independientemente de las obras
  resources :terceros

  # ver /cheques y filtrarlos por situacion
  resources :cheques, only: [ :index, :show ] do
    collection do
      get 'propios'
      get 'terceros'
    end
  end

end
