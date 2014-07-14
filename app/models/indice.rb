# encoding: utf-8
class Indice < ActiveRecord::Base
  has_many :cuotas
  validates_presence_of :periodo, :denominacion, :valor

  # cuando se actualiza un índice a su valor definitivo deja de ser
  # temporal
  before_update :ahora_es_definitivo
  after_update  :actualizar_cuotas

  def temporal?
    temporal
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
