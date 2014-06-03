# encoding: utf-8
require 'test_helper'

class SarasaController < ApplicationController
end

class ApplicationControllerTest < ActionController::TestCase
  setup do
    @controlador = SarasaController.new
  end

  test 'es un controlador' do
    assert_kind_of ApplicationController, @controlador
  end

  test 'busca factura por id si el controlador es de facturas' do
    @controlador.stub :params, { controller: 'facturas' } do
      assert_equal :id, @controlador.send(:id_para_factura)
    end
  end

  test 'busca factura por factura_id' do
    @controlador.stub :params, { controller: 'otro' } do
      assert_equal :factura_id, @controlador.send(:id_para_factura)
    end
  end

  test 'carga la obra si hay un id' do
    obra = create(:obra)

    @controlador.stub :params, { obra_id: obra.id } do
      assert_equal obra, @controlador.send(:set_obra)
    end
  end

  test 'no carga la obra si no hay id' do
    @controlador.stub :params, { obra_id: nil } do
      assert_equal nil, @controlador.send(:set_obra)
    end
  end

  test 'carga la factura a través de su obra' do
    factura = create :factura
    obra = Minitest::Mock.new
    obra.expect :present?, true
    obra.expect :facturas, factura.obra.facturas
    @controlador.instance_variable_set '@obra', obra

    @controlador.stub :params, { factura_id: factura.id  } do
      assert_equal factura, @controlador.send(:set_factura)
    end

    assert obra.verify
  end

  test 'mantiene un array de causas conocidas' do
    causas = @controlador.send(:causas_conocidas)
    assert_instance_of Array, causas
    %w{
      cheque-propio cheque-de-terceros retenciones efectivo transferencia
    }.each do |causa|
      assert causas.include? causa
    end
  end

  test 'no carga clases de causas desconocidas' do
    causas = Minitest::Mock.new
    causas.expect :include?, false, [ String ]

    @controlador.stub :causas_conocidas, causas do
      @controlador.stub :params, { causa_tipo: 'causa-hax0r' } do
        assert_nil @controlador.send(:modelo_de_causa)
      end
    end

    assert causas.verify
  end

  test 'carga las clases de causas conocidas' do
    @controlador.stub :params, { causa_tipo: 'efectivo' } do
      assert_equal Efectivo, @controlador.send(:modelo_de_causa)
    end
  end

  test 'cheque-propio es un Cheque' do
    @controlador.stub :params, { causa_tipo: 'cheque-propio' } do
      assert_equal Cheque, @controlador.send(:modelo_de_causa)
    end
  end

  test 'cheque-de-terceros es un Cheque' do
    @controlador.stub :params, { causa_tipo: 'cheque-de-terceros' } do
      assert_equal Cheque, @controlador.send(:modelo_de_causa)
    end
  end

  test 'Retencion viene en plural' do
    @controlador.stub :params, { causa_tipo: 'retenciones' } do
      assert_equal Retencion, @controlador.send(:modelo_de_causa)
    end
  end
end
