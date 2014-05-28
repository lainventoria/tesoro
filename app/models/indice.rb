# encoding: utf-8
class Indice < ActiveRecord::Base
  validates_presence_of :periodo
  validates_presence_of :denominacion
  validates_presence_of :valor
end
