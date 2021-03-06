# encoding: utf-8
require 'test_helper'

class CajaTest < ActiveSupport::TestCase
  setup do
    # Caja sin movimientos para la mayoría de los tests
    @caja = create :caja
  end

  test 'las cuentas deben tener banco' do
    refute build(:cuenta, banco: nil).valid?
  end

  test 'unifica los tipos prefiriendo el existente' do
    tipo_existente = 'Cajón sarasa'
    create(:caja, tipo: tipo_existente)

    assert_equal tipo_existente, create(:caja, tipo: ' Cajón    sarasa ').tipo
    assert_equal tipo_existente, create(:caja, tipo: 'Cajon sarasa').tipo
    assert_equal tipo_existente, create(:caja, tipo: 'cajón sarasa').tipo
  end

  test 'no permite tipos iguales en una misma obra y con el mismo numero' do
    create :caja, tipo: 'Personal', obra_id: '1234', numero: ''

    # no permite cajas con mismo tipo
    assert_raise ActiveRecord::RecordInvalid do
      create :caja, tipo: 'Personal', obra_id: '1234', numero: ''
    end

    # a menos que tengan numeros diferentes
    assert create :caja, tipo: 'Personal', obra_id: '1234', numero: '1'
  end

  test 'emite cheques propios' do
    cheque = @caja.emitir_cheque(
      attributes_for(:cheque, monto: Money.new(100))
    )

    assert_instance_of Cheque, cheque
    assert cheque.propio?
    assert_equal Money.new(100), cheque.monto
    assert_equal @caja.obra.chequera_propia, cheque.chequera
  end

  test 'no permite archivar hasta que el saldo es 0' do
    ['ARS', 'USD'].each do |moneda|
      assert @caja.depositar!(Money.new(1000, moneda))

      assert_not @caja.archivar, @caja.errors.inspect

      assert @caja.extraer!(Money.new(1000, moneda))
    end

    assert @caja.archivar, @caja.errors.inspect
  end
end
