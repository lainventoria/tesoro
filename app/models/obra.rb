class Obra < ActiveRecord::Base
  has_one :caja
  has_one :cuenta

  after_create :create_caja, :create_cuenta
end
