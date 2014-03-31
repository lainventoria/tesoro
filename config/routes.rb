Cp::Application.routes.draw do
  root 'obras#index'

  resources :obras do

    resources :facturas do
    # Filtrar facturas por situacion
      collection do
        get 'cobros'
        get 'pagos'
      end

      # Ver los recibos de cada factura
      resources :recibos

      # Ver las retenciones de cada factura
      resources :retenciones
    end

    # Permitir /recibos pero no crear recibos sin facturas asociadas
    resources :recibos, except: [ :new ] do
      collection do
        get 'cobros'
        get 'pagos'
      end
    end

    resources :cajas do
      resources :cheques
    end

    resources :retenciones, only: [ :index, :show ]
  end

  resources :cajas do
    # TODO borrar ':new' cuando ya exista interfase de carga
    resources :cheques, only: [ :index, :show, :new, :create, :update, :destroy, :edit ] 
  end

  resources :facturas, except: [ :index ] do
  # Filtrar facturas por situacion
    collection do
      get 'cobros'
      get 'pagos'
    end

    # Autocompletar Terceros
    get :autocomplete_tercero_nombre, :on => :collection
    get :autocomplete_tercero_cuit, :on => :collection

    # Ver los recibos de cada factura
    resources :recibos

    resources :causas, only: [ :new ]

    # Ver las retenciones de cada factura
    resources :retenciones
  end

  # Permitir /recibos pero no crear recibos sin facturas asociadas
  resources :recibos, except: [ :new, :index, :create ] do
    collection do
      get 'cobros'
      get 'pagos'
    end
  end

  resources :terceros

  # TODO borrar ':new' cuando ya exista interfase de carga
  resources :cheques, only: [ :index, :show, :new, :create, :update, :destroy, :edit ]

  resources :retenciones, except: [ :new ]
end
