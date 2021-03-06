# encoding: utf-8
class Factura < ActiveRecord::Base
  # Las situaciones posibles en que se genera una factura
  SITUACIONES = %w(cobro pago)

  # Las facturas pertenecen a un tercero
  belongs_to :tercero, inverse_of: :facturas
  belongs_to :obra, inverse_of: :facturas

  # Las facturas se pueden cancelar con muchos recibos
  has_many :recibos, inverse_of: :factura, dependent: :restrict_with_error

  # Puede tener varias retenciones de varios tipos
  has_many :retenciones, inverse_of: :factura, dependent: :restrict_with_error

  # Sólo aceptamos esas :3
  validates_inclusion_of :situacion, in: SITUACIONES
  validates_numericality_of :importe_neto, greater_than_or_equal_to: 0
  validates_numericality_of :importe_total, greater_than_or_equal_to: 0
  validates_presence_of :obra, :tercero

  validate :validate_saldo

  accepts_nested_attributes_for :tercero

  monetize :importe_neto_centavos, with_model_currency: :importe_neto_moneda
  monetize :importe_total_centavos, with_model_currency: :importe_total_moneda
  monetize :iva_centavos, with_model_currency: :iva_moneda

  # Mantener actualizados los valores calculados cada vez que se hace
  # una modificación
  before_validation :calcular_importe_total

  normalize_attribute :tipo, with: [ :strip, :blank, { truncate: { length: 1 } }, :upcase ]

  def self.tipos_invalidos
    pluck(:tipo).uniq.reject { |t|
      Cp::Application.config.tipos_validos.include? t
    }
  end

  def self.por_saldar
    where({}).reject { |f| f.saldo == Money.new(0) }
  end

  def self.saldadas
    where({}).reject { |f| f.saldo > Money.new(0) }
  end

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
    saldo == Money.new(0)
  end

  # se fija si la factura es de un tipo considerado valido
  def tipo_valido?
    Cp::Application.config.tipos_validos.include? tipo
  end

  def tipo_invalido?
    not tipo_valido?
  end

  # Si el saldo es menor al importe_total es porque se pagó de más
  # Con las validaciones de Recibo no debería hacer falta
  # TODO ver dónde se usa
  def reintegro?
    saldo < importe_total
  end

  # Calcula el reintegro si se pagó de más
  # Con las validaciones de Recibo no debería hacer falta
  # TODO ver dónde se usa
  def reintegro
    saldo * -1 if reintegro?
  end

  # Calcula el saldo, o sea cuánto se adeuda de esta factura en base a todos
  # los recibos. Esto asume que los recibos se hacen en la misma moneda de la
  # factura (y no que se está pagando una parte en una y otra en otra)
  #
  # Antes de guardar un recibo se tiene que hacer la validación a la
  # moneda de la factura
  def saldo
    importe_total - recibos.collect(&:importe_cache).sum.to_money(importe_total_moneda)
  end

  # El importe total o bruto es el neto con el IVA incluido
  def calcular_importe_total
    self.importe_total = importe_neto + iva

    # los callbacks necesitan true o algo que evalue a true
    true
  end

  # TODO esto en realidad tiene que calcular el saldo en base a los
  # recibos en memoria, no a los que ya están en la base de datos
  def validate_saldo
    errors.add :recibos, :sobrepasan_el_importe_total if saldo.negative?
  end

  # setear magicamente el tercero si no pasamos uno existente
  def tercero_attributes=(attributes = {})
    if tercero_id.nil?
      self.tercero = Tercero.where(attributes.merge({ relacion: 'ambos' })).first_or_create
    end
  end

  # si tenemos un recibo de retenciones lo devolvemos
  # este recibo se crea al crear una retencion y se edita al intentar crear
  # un recibo manualmente
  def recibo_de_retenciones
    recibos.last if recibos.last.present? and recibos.last.solo_tiene_retenciones?
  end
end
