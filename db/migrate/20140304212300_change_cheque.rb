class ChangeCheque < ActiveRecord::Migration
  def up
    remove_column :cheques, :fecha
    add_column :cheques, :fecha_emision, :timestamp

    add_reference :cheques, :recibo, index: true

    add_column :cheques, :beneficiario, :string

    add_column :cheques, :banco, :string
  end

  def down
    add_column :cheques, :fecha, :timestamp
    remove_column :cheques, :fecha_emision

    remove_reference :cheques, :recibo

    remove_column :cheques, :beneficiario

    remove_column :cheques, :banco
  end

end
