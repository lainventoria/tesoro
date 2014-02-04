# encoding: utf-8
class Caja < ActiveRecord::Base
  belongs_to :obra
  has_many :movimientos

  validates_presence_of :obra_id, :tipo

  # Garantiza que los nuevos tipos escritos parecido a los viejos se corrijan
  # con los valores viejos
  normalize_attribute :tipo, with: [ :squish, :blank ] do |valor|
    tipos_normalizados = tipos.inject({}) do |hash_de_tipos, tipo|
      hash_de_tipos[tipo.parameterize] = tipo and hash_de_tipos
    end

    if tipos_normalizados.keys.include?(valor.parameterize)
      tipos_normalizados[valor.parameterize]
    else
      valor
    end
  end

  def self.tipos
    pluck(:tipo).uniq
  end

  # TODO ver si hace falta un caso especial con movimientos sin guardar
  def total(moneda = 'ARS')
    Money.new(movimientos.where(monto_moneda: moneda).sum(:monto_centavos), moneda)
  end

  def totales
    if movimientos.empty?
      { 'ARS' => Money.new(0) }
    else
      movimientos.pluck(:monto_moneda).uniq.inject({}) do |hash, moneda|
        hash[moneda] = total(moneda)
        hash
      end
    end
  end

  # El cambio de moneda registra la transacción con un movimiento de salida
  # (negativo) y un movimiento de entrada en la nueva moneda.
  #
  # Este índice de cambio no se registra en el banco default
  def cambiar(cantidad, moneda, indice)
    cambio = Money.new(0)

    # Sólo si la caja tiene suficiente saldo devolvemos el monto convertido
    Caja.transaction do
      cantidad.bank.exchange cantidad.fractional, indice do |nuevo|
        unless extraer(cantidad)
          raise ActiveRecord::Rollback, 'Monto insuficiente'
        end
        cambio = depositar Money.new(nuevo, moneda)
      end
    end

    cambio
  end

  # Sólo si la caja tiene suficiente saldo devolvemos el monto convertido,
  # caso contrario no devolvemos nada
  def extraer(cantidad)
    if cantidad <= total(cantidad.currency.iso_code)
      depositar(cantidad * -1)
      cantidad
    end
  end

  # Devolvemos cantidad para mantener consistente la API
  def depositar(cantidad)
    movimientos.create monto: cantidad
    cantidad
  end
end
