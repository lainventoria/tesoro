class AddRelacionIndiceToContrato < ActiveRecord::Migration
  def change
    add_column :contratos_de_venta, :relacion_indice, :string, null: false
  end
end
