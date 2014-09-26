set :branch, 'feature/demo-cambia-color-barra-navegacion'
set :rails_env, :production
set :deploy_user, 'gestionar'
set :deploy_host, 'gestionar.lainventoria.com.ar'
set :deploy_to, "/srv/http/#{fetch(:deploy_host)}"

# En los servers seguros /tmp está montado como noexec
set :tmp_dir, "#{fetch(:deploy_to)}/tmp"

server fetch(:deploy_host), port: 22, user: fetch(:deploy_user), roles: %w{app web db}

