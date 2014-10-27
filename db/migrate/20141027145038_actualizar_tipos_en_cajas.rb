class ActualizarTiposEnCajas < ActiveRecord::Migration
  def up
    Caja.where(tipo: 'Administración X').update_all tipo: 'Administración B'
    Caja.where(tipo: 'Chequera X').update_all tipo: 'Cheques en Cartera B'
    Caja.where(tipo: 'Caja de Ahorro').update_all tipo: 'Cta. Corriente'
    Caja.where(tipo: 'Chequera').update_all tipo: 'Cheques en Cartera'
    Caja.where(tipo: 'Chequera propia').update_all tipo: 'Cheques Propios'
  end

  def down
    Caja.where(tipo: 'Administración B').update_all tipo: 'Administración X'
    Caja.where(tipo: 'Cheques en Cartera B').update_all tipo: 'Chequera X'
    Caja.where(tipo: 'Cta. Corriente').update_all tipo: 'Caja de Ahorro'
    Caja.where(tipo: 'Cheques en Cartera').update_all tipo: 'Chequera'
    Caja.where(tipo: 'Cheques Propios').update_all tipo: 'Chequera propia'
  end
end
