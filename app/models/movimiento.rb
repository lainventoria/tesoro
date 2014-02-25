class Movimiento < ActiveRecord::Base
  belongs_to :caja
  belongs_to :recibo, inverse_of: :movimientos

  monetize :monto_centavos, with_model_currency: :monto_moneda

  validates_presence_of :caja, :recibo, :monto
  before_create :crear_recibo_adhoc


  private

    # Crear un recibo para este movimiento si no se están generando
    # movimientos a partir de un recibo
    def crear_recibo_adhoc
      return if not self.recibo.nil?

      recibo = Recibo.create(importe: self.monto,
                             situacion: 'interno',
                             fecha: Time.now)
    end

end
