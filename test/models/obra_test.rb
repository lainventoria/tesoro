require 'test_helper'

class ObraTest < ActiveSupport::TestCase
  test 'crea su cuenta asociada al crearse' do
    obra = create :obra

    assert_instance_of Cuenta, obra.cuenta
    assert obra.cuenta.id == obra.id
  end

  test 'crea su caja asociada al crearse' do
    obra = create :obra

    assert_instance_of Caja, obra.caja
    assert obra.caja.id == obra.id
  end
end
