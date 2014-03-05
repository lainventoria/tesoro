# Los cheques son promesas de cobro o pago, es decir que son movimientos
# futuros
# Solo se pueden depositar cuando están vencidos 
# Solo cuando se depositan generan un movimiento (positivo o negativo)
# en el recibo al que pertenecen
class Cheque < ActiveRecord::Base
  belongs_to :cuenta
  belongs_to :recibo, inverse_of: :cheques

  SITUACIONES = %w(propio terceros)
  validates_inclusion_of :situacion, in: SITUACIONES
  validates_presence_of :fecha_vencimiento, :monto
  # Todos los cheques propios tienen una cuenta
  validates_presence_of :cuenta_id, if: :propio?

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
    return nil if :tercero?
# TODO hasta que mergee recibos-movimientos
  end
end
