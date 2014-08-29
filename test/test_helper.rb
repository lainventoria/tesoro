# encoding: utf-8
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/mock'
require 'database_cleaner'
require 'minitest/rails'
require 'minitest/rails/capybara'

# Borrar todas las tablas de la DB
DatabaseCleaner.clean_with :truncation

class ActiveSupport::TestCase
  # Permite usar create, build, etc directamente
  include FactoryGirl::Syntax::Methods

  ActiveRecord::Migration.check_pending!

  setup do
    # Iniciar la transacción
    DatabaseCleaner.start
  end

  teardown do
    # Rollbackear así el siguiente test está con estado limpio
    DatabaseCleaner.clean
  end

  # Prueba que la fábrica construya objetos válidos, :build por default
  def assert_valid_factory(metodo, tipo)
    coso = FactoryGirl.send(metodo, tipo)
    assert coso.valid?, "#{metodo}: #{coso.errors.messages.inspect}"
  end

  def efectivo_por(monto)
    Efectivo.new caja: create(:caja, :con_fondos), monto: monto
  end
end

# Tests de integración
class Capybara::Rails::TestCase
  include ApplicationHelper

  # No podemos usar transacciones con selenium
  DatabaseCleaner.strategy = :truncation
  self.use_transactional_fixtures = false

  teardown do
    DatabaseCleaner.clean
    # Reiniciar el estado del navegador
    Capybara.reset_sessions!
    # Volver al driver default si lo cambiamos a selenium temporalmente
    Capybara.use_default_driver
  end

  # Para los tests de integración que dependen de estos datos
  def cargar_seeds
    load Rails.root.join('db/seeds.rb')
  end
end

# Registrando el driver podemos pasar opciones como el profile a usar
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new app, browser: :firefox, profile: ENV['PROFILE']
end
