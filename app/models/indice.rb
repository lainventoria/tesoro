# encoding: utf-8
class Indice < ActiveRecord::Base
  has_many :cuotas
  validates_presence_of :periodo, :denominacion, :valor
end
