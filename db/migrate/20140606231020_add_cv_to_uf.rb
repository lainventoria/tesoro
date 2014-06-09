class AddCvToUf < ActiveRecord::Migration
  def change
    add_reference :unidades_funcionales, :contrato_de_venta, index: true
  end
end
