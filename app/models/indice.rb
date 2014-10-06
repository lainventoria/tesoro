# encoding: utf-8
class Indice < ActiveRecord::Base
  DENOMINACIONES = ['Costo de construcción', 'Materiales', 'Mano de obra']

  has_many :cuotas
  has_many :contratos_de_venta
  validates_presence_of :periodo, :denominacion, :valor
  validates_inclusion_of :denominacion, in: DENOMINACIONES
  validates_uniqueness_of :denominacion, scope: :periodo
  validates_numericality_of :valor

  after_update :indexar_al_ultimo, :actualizar_cuotas, if: :valor_changed?

  # Traer todos los índices temporales siguientes a este índice y por lo
  # tanto afectados por sus actualizaciones
  def temporales_siguientes
    Indice.where(temporal: true).
      where('periodo > ?', periodo).order(periodo: :asc)
  end

  # Trae el índice del mismo tipo siguiente a este
  def siguiente
    Indice.where(denominacion: denominacion).
      where('periodo > ?', periodo).
      order(periodo: :asc).
      first
  end

  def temporal?
    temporal
  end

  def self.hay_alguno_este_mes?(denominacion)
    where(denominacion: denominacion).
      where(periodo: Date.today.beginning_of_month).
      where(temporal: false).
      any?
  end

  def self.por_fecha_y_denominacion(fecha, denominacion)
    periodo = fecha.beginning_of_month

    # obtener el índice para este período
    indice = Indice.where(periodo: periodo).
      where(denominacion: denominacion).
      order(:periodo).
      first

    # si no existe ese índice
    if indice.nil?
      # obtener el último índice disponible
      indice_anterior = Indice.where(denominacion: denominacion).
        order(:periodo).last

      raise 'Faltan los índices' if indice_anterior.nil?

      # y crear un índice temporal con el valor del último índice
      # disponible
      indice = Indice.new(temporal: true,
        denominacion: denominacion,
        periodo: periodo,
        valor: indice_anterior.valor)
      indice.save!
    end

    # devolver siempre un indice
    indice
  end

  private

    # actualiza el monto de las facturas cuando se modifica el indice
    def actualizar_cuotas
      Factura.transaction do
        cuotas.each do |cuota|
          if cuota.factura.present?
            cuota.factura.importe_neto = cuota.monto_actualizado
            cuota.factura.save!
          end
        end
      end
    end

    # cuando se actualiza este índice, se actualiza el temporal
    # siguiente hasta que nos encontramos con uno que no es
    def indexar_al_ultimo
      Indice.transaction do
        siguiente.update(valor: valor) if siguiente.try(:temporal?)
      end
    end
end
