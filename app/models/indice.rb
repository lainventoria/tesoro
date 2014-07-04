# encoding: utf-8
class Indice < ActiveRecord::Base
  has_many :cuotas
  validates_presence_of :periodo, :denominacion, :valor
  DENOMINACIONES = ["Costo de construcción", "Materiales", "Mano de obra"]

  # cuando se actualiza un índice a su valor definitivo deja de ser
  # temporal
  before_update :ahora_es_definitivo
  after_update  :actualizar_cuotas

  def temporal?
    temporal
  end

  def self.porFechaYDenominacion ( fecha, denominacion )
    # obtener el indice para este periodo
    indice = Indice.where(periodo: periodo).
      where(denominacion: contrato_de_venta.indice.denominacion).
      order(:periodo).
      first

    # si no existe ese indice
    if indice.nil?
      # obtener el último indice disponible
      indice_anterior = Indice.where(denominacion: contrato_de_venta.indice.denominacion).
        order(:periodo).last

      # y crear un indice temporal con el valor del ultimo indice
      # disponible
      indice = Indice.new(temporal: true,
        denominacion: contrato_de_venta.indice.denominacion,
        periodo: periodo,
        valor: indice_anterior.valor)
    end

    # actualizar el indice que estamos usando
    self.indice = indice

    # devolver siempre un indice
    indice
  end

  private

    def ahora_es_definitivo
      self.temporal = false

      # no dejar que temporal devuelva false
      true
    end

    # actualiza el monto de las facturas cuando se modifica el indice
    def actualizar_cuotas
      Factura.transaction do
        cuotas.each do |cuota|
          if !cuota.factura.nil?
            cuota.factura.importe_neto = cuota.monto_actualizado
            cuota.factura.save
          end
        end
      end
    end
end
