# encoding: utf-8
require 'test_helper'

class Sarasa
  include CausaDeMovimientos
end

class CausaDeMovimientosTest < ActiveSupport::TestCase
  test 'exige saber cómo usarse para pagar' do
    assert_raises NotImplementedError { Sarasa.new.usar_para_pagar 'algo' }
  end

  test 'exige saber construirse' do
    assert_raises NotImplementedError { Sarasa.construir({ algo: 'bonito'}) }
  end
end
