# encoding: utf-8
class Indice < ActiveRecord::Base
  has_many :cuotas
  validates_presence_of :periodo, :denominacion, :valor

  # cuando se actualiza un índice a su valor definitivo deja de ser
  # temporal
  before_update :ahora_es_definitivo

  def temporal?
    temporal
  end

  private

    def ahora_es_definitivo
      self.temporal = false
    end
end
