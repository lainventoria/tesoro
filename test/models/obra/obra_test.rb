# encoding: utf-8
require 'test_helper'

class ObraTest < ActiveSupport::TestCase
  test 'crea sus cajas asociadas al crearse' do
    obra = create :obra

    assert_equal 10, obra.cajas.count
    assert_equal 1, obra.cajas.where(tipo: 'Obra').count
    assert_equal 1, obra.cajas.where(tipo: 'Administración').count
    assert_equal 1, obra.cajas.where(tipo: 'Administración B').count
    assert_equal 1, obra.cajas.where(tipo: 'Seguridad').count
    assert_equal 1, obra.cajas.where(tipo: 'Cuenta Corriente').count
    assert_equal 1, obra.cajas.where(tipo: 'Cheques en Cartera').count
    assert_equal 1, obra.cajas.where(tipo: 'Cheques Propios').count
    assert_equal 1, obra.cajas.where(tipo: 'Cheques en Cartera B').count
    assert_equal 1, obra.cajas.where(tipo: 'Retenciones de Ganancias').count
    assert_equal 1, obra.cajas.where(tipo: 'Retenciones de Cargas Sociales').count
  end
end
