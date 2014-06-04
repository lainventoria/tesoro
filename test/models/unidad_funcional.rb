# encoding: utf-8
require 'test_helper'

class UnidadFuncionalTest < ActiveSupport::TestCase

  test 'es válida' do
     [ :build, :build_stubbed, :create ].each do |metodo|
      assert_valid_factory metodo, :unidad_funcional
    end
  end

end
