class Obra < ActiveRecord::Base
  has_many :cajas
  has_one :cuenta

  after_create :create_cuenta

  validates_presence_of :nombre, :direccion

end
