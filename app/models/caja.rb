class Caja < ActiveRecord::Base
  belongs_to :obra
  has_many :movimientos
end
