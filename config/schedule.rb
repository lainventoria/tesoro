# Acá se definen los cron jobs.
# Más sintaxis: http://github.com/javan/whenever

# Una vez al día revisar las cuotas vencidas y crear una factura por cada una
every 1.day, at: '12:01 am' do
  # rake 'gestionar:cuotas_vencidas'
end
