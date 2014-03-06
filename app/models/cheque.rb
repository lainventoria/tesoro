# Los cheques son promesas de cobro o pago, es decir que son movimientos
# futuros
# Solo se pueden depositar cuando están vencidos 
# Solo cuando se depositan generan un movimiento (positivo o negativo)
# en el recibo al que pertenecen
class Cheque < ActiveRecord::Base
  belongs_to :caja
  belongs_to :recibo, inverse_of: :cheques

  SITUACIONES = %w(propio terceros)
  validates_inclusion_of :situacion, in: SITUACIONES
  # campos requeridos
  validates_presence_of :fecha_emision, :fecha_vencimiento, :monto,
                        :beneficiario
  # Todos los cheques propios tienen una caja
  validates_presence_of :caja_id, if: :propio?

  # todos los cheques tiene un recibo
  validates_presence_of :recibo_id

  monetize :monto_centavos

  # Trae todos los cheques vencidos, si se le pasa una fecha trae los
  # vencidos a ese momento
  scope :vencidos, lambda { |time = nil|
    time = Time.now if not time
    where("fecha_vencimiento < ?", time)
  }

  def vencido?
    fecha_vencimiento < Time.now
  end

  def propio?
    situacion == 'propio'
  end

  def terceros?
    situacion == 'terceros'
  end

  # al depositar un cheque se genera un movimiento en el recibo de este
  # cheque y se marca como estado = depositado
  def depositar
    # solo los cheques de terceros se depositan
    return nil if :propio?

    recibo.movimientos.create(monto: self.monto, recibo: self.recibo)


  end
end
