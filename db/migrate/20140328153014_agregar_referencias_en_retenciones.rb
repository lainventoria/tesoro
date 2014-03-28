class AgregarReferenciasEnRetenciones < ActiveRecord::Migration
  def change
    add_reference :retenciones, :cuenta, index: true
    add_reference :retenciones, :caja_afip, index: true
  end
end
