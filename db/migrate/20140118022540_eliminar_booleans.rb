class EliminarBooleans < ActiveRecord::Migration
  def change
    remove_column :recibos, :emitido
    remove_column :recibos, :recibido

    remove_column :facturas, :recibida
    remove_column :facturas, :emitida

    add_column :facturas, :emitida_o_recibida, :string
    add_column :recibos, :emitido_o_recibido, :string
  end
end
