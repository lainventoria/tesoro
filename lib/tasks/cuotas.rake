namespace :gestionar do
  desc 'Genera facturas para cada cuota vencida al día de hoy'
  task :cuotas_vencidas => :environment do
    facturas_actuales = Factura.count
    cuotas_procesadas = Cuota.facturar_vencidas

    puts I18n.t('tareas.gestionar.cuotas_vencidas.cuotas_procesadas',
      count: cuotas_procesadas.size)
    puts I18n.t('tareas.gestionar.cuotas_vencidas.facturas_generadas',
      count: Factura.count - facturas_actuales)
  end
end
