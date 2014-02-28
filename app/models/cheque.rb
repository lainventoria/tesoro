class Cheque < ActiveRecord::Base
  belongs_to :cuenta

  SITUACIONES = %w(propio terceros)
  validates_inclusion_of :situacion, in: SITUACIONES
  validates_presence_of :fecha_vencimiento, :monto
  validates_presence_of :cuenta_id, unless: :terceros?

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
end
