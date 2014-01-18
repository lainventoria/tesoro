class Caja < ActiveRecord::Base
  belongs_to :obra
  has_many :movimientos

  validates_presence_of :obra_id

  # TODO ver si hace falta un caso especial con movimientos sin guardar
  def total(moneda = 'ARS')
    Money.new(movimientos.where(monto_moneda: moneda).sum(:monto_centavos), moneda)
  end
end
