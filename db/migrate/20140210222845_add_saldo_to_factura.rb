class AddSaldoToFactura < ActiveRecord::Migration
  def change
    add_column :facturas, :saldo, :money
  end
end
