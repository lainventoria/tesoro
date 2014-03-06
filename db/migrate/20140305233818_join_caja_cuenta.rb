class JoinCajaCuenta < ActiveRecord::Migration
  def change
    add_column :cajas, :banco, :string
    add_column :cajas, :numero, :string
    add_column :cajas, :situacion, :string

    drop_table :cuentas

    remove_reference :cheques, :cuenta
    add_reference :cheques, :caja, index: true

  end
end
