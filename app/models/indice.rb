# encoding: utf-8
class Indice < ActiveRecord::Base
  validates_presence_of :periodo, :denominacion, :valor
end
