require 'test_helper'

class CuotaTest < ActiveSupport::TestCase
  test "es válida" do
    [ :build, :build_stubbed, :create].each do |metodo|
      assert_valid_factory metodo, :cuota
    end
  end

end
