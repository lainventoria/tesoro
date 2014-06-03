# encoding: utf-8
require 'test_helper'

class IndiceTest < ActiveSupport::TestCase
  test "es válido" do
    [ :build, :build_stubbed, :create ].each do |metodo|
      assert_valid_factory metodo, :indice
    end
  end

  test "necesita un periodo" do
    assert i = build(:indice, periodo: nil)
    assert_not i.save
  end

  test "necesita una denominacion" do
    assert i = build(:indice, denominacion: nil)
    assert_not i.save
  end

  test "necesita un valor" do
    assert i = build(:indice, valor: nil)
    assert_not i.save
  end
end
