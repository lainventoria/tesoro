# encoding: utf-8
require 'test_helper'

class IndiceTest < ActiveSupport::TestCase
  test "es válido" do
    [ :build, :build_stubbed, :create].each do |metodo|
      assert_valid_factory metodo, :indice
    end
  end
end
