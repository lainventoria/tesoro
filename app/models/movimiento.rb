class Movimiento < ActiveRecord::Base
  belongs_to :caja
  belongs_to :recibo, inverse_of: :movimientos

  monetize :monto_centavos, with_model_currency: :monto_moneda

  validates_presence_of :caja, :recibo, :monto
  # No dejar movimiento sin recibo, ver nota abajo igual
  before_validation :crear_recibo_interno


  private

    # ESTO VA EN LAS TRANSACCIONES DE CAJA
    # para que varios movimientos compartan el mismo recibo

    # Crear un recibo para este movimiento si no se están generando
    # movimientos a partir de un recibo como burocracia interna
    def crear_recibo_interno
      return if not self.recibo.nil?

      recibo = Recibo.create(importe: 0,
                             situacion: 'interno',
                             fecha: Time.now)
    end

end
