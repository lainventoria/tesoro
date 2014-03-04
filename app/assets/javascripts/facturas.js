$(document).ready(function(){
// Inicializar los datepicker
  $('.input-group.date').datepicker({
    format: "dd M yyyy",
    weekStart: 1,
    autoclose: true,
    language: "es",
    forceParse: false
  });

// cuando se hace un cambio en IVA o importe neto, calcular el importe
// bruto
  $('#factura_importe_neto').on('keyup', function() {
    $('#factura_importe_total')[0].value = parse_float($('#factura_importe_neto')[0].value) + parse_float($('#factura_iva')[0].value);
  });

  $('#factura_iva').on('keyup', function() {
    $('#factura_importe_total')[0].value = parse_float($('#factura_importe_neto')[0].value) + parse_float($('#factura_iva')[0].value);
  });
});
