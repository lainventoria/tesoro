source 'https://rubygems.org'

gem 'rails', '4.1.4'

# Modelos

gem 'money-rails', '~> 0.12.0'
# Normaliza con varios métodos la entrada de usuario
gem 'attribute_normalizer'
gem 'paperclip'
# Fork con pull requests para rails 4.1 mergeados
gem 'state_machine', github: 'lainventoria/state_machine'

# DB
# Permite importar y exportar datos en formato yml
gem 'yaml_db', github: 'mauriciopasquier/yaml_db'
gem 'mysql2', '~> 0.3.20'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# Assets/GUI

gem 'sass-rails', '~> 4.0.0'
gem 'bootstrap-sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'turbolinks'
# Selector de fechas con calendario mensual
gem 'bootstrap-datepicker-rails'
# Error messages
gem 'dynamic_form'
# Autocomplete en formularios
gem 'rails3-jquery-autocomplete'
gem 'jquery-ui-rails'
gem 'jquery-ui-themes'
# Selector de archivos bootstrapeado
gem 'bootstrap-filestyle-rails'
gem 'therubyracer'

# I18n
gem 'rails-i18n'
gem 'inflections', '0.0.5', require: 'inflections/es'

# Soporte

# Para definir cronjobs
gem 'whenever'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  gem 'spring'
  # Deploy con capistrano
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  # Dibujar máquinas de estado
  gem 'ruby-graphviz'
end

group :development, :test do
  gem 'pry-rails'
  gem 'hirb'
  # Usar fábricas en vez de fixtures
  gem 'factory_girl_rails'
  gem 'better_errors'
  gem 'binding_of_caller'
  # Guardar variables de entorno en .env
  gem 'dotenv-rails'
end

group :test do
  # Para limpiar la base de datos después de cada test
  gem 'database_cleaner'
  # Para los tests de integración
  gem 'selenium-webdriver'
  gem 'minitest-rails-capybara'
end

group :production do
  # Servidor para produccion
  gem 'thin'
end
