# encoding: utf-8
require 'test_helper'

class ContratoDeVentaTest < ActiveSupport::TestCase
  test "es válido" do
    [ :build, :build_stubbed, :create ].each do |metodo|
      assert_valid_factory metodo, :contrato_de_venta
    end
  end
end
