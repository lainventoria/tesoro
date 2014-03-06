class AddEstadoToCheques < ActiveRecord::Migration
  def change
    add_column :cheques, :estado, :string, default: 'chequera'
  end
end
