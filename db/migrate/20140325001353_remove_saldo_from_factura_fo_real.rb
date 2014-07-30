class RemoveSaldoFromFacturaFoReal < ActiveRecord::Migration
  def change
    remove_column :facturas, :saldo_moneda, :string, default: 0, null: false
    remove_column :facturas, :saldo_centavos, :integer, default: 'ARS', null: false
  end
end
