# encoding: utf-8
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

  ESTADOS = %w(chequera depositado cobrado rechazado pagado)
  validates_inclusion_of :estado, in: ESTADOS

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

  # Trae todos los cheques depositados
  scope :depositados, lambda {
    where(estado: 'depositado')
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

  def depositado?
    estado == 'depositado'
  end

  def pagado?
    estado == 'pagado'
  end

  # para poder cobrar un cheque de terceros, antes se deposita y se
  # espera que el banco lo verifique
  def depositar
    # solo los cheques de terceros se depositan
    return nil unless self.terceros?

    self.estado = 'depositado'
  end

  # al cobrar un cheque se genera un movimiento en el recibo de este
  # cheque y se marca como estado = cobrado
  def cobrar
    # solo los cheques depositados se pueden cobrar
    return nil unless self.depositado?

    Cheque.transaction do
      self.caja.depositar(self.monto, true, self.recibo)

      self.estado = 'cobrado'
    end

    # devolver el movimiento
    self.caja.movimientos.last
  end

  # Los cheques propios generan movimientos de salida (negativos) cuando
  # se pagan
  def pagar
    # Solo los cheques propios se pueden pagar
    return nil unless self.propio?
    # Los cheques pagados no se pueden pagar dos veces!
    return nil if self.pagado?

    # Usamos las operaciones de caja
    Cheque.transaction do
      self.caja.extraer(self.monto, true, self.recibo)
      self.estado = 'pagado'
    end

    self.caja.movimientos.last
  end
end
