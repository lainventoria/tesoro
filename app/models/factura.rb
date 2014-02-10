class Factura < ActiveRecord::Base
  # Las facturas se pueden cancelar con muchos recibos
  has_many :recibos, inverse_of: :factura

  # Las situaciones posibles en que se genera una factura
  SITUACIONES = %w(cobro pago)
  # Sólo aceptamos esas :3
  validates_inclusion_of :situacion, in: SITUACIONES

  monetize :importe_total_centavos

  # Chequea si la situación es pago
  def pago?
    situacion == 'pago'
  end

  # Chequea si la situación es cobro
  def cobro?
    situacion == 'cobro'
  end

  # La factura está cancelada cuando el saldo es 0
  def cancelada?
    saldo == 0
  end

  # Si el saldo es menor al importe_total es porque se pagó de más
  # Con las validaciones de Recibo no debería hacer falta
  def reintegro?
    saldo < importe_total
  end

  # Calcula el reintegro si se pagó de más
  # Con las validaciones de Recibo no debería hacer falta
  def reintegro
    saldo * -1 if reintegro?
  end

	def nombre_y_numero
		"[#{numero}] #{nombre}"
	end

	def to_s
		nombre_y_numero
	end
end
