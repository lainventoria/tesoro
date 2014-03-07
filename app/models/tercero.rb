# encoding: utf-8
class Tercero < ActiveRecord::Base
  include ApplicationHelper

  # Cada tercero esta asociado a muchas facturas
  has_many :facturas, inverse_of: :tercero

  # Las relaciones posibles que se pueden tener con cada tercero
  RELACIONES = %w(cliente proveedor ambos)

  # Validacionesi
  validates_inclusion_of :relacion, in: RELACIONES
  validates_presence_of :nombre, :cuit
  validate :cuit
  validates_uniqueness_of :cuit

  def validate_cuit
    errors[:base] << "El CUIT no es válido" if not validar_cuit(self.cuit)
  end

end
