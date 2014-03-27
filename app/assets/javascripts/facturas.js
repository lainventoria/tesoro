$(document).ready(function(){

  // calcula el total cuando se hace un cambio en IVA o importe neto
  $('.calcula_total').on('keyup', function() {
    importe_total = parseFloat($('#factura_importe_neto').autoNumeric('get')) + parseFloat($('#factura_iva').autoNumeric('get'));
    $('#factura_importe_total').autoNumeric('set', importe_total );
  });


  // Cuando cambie el nombre del tercero cuando actualicemos el cuit
  $('#cuit_tercero').bind('railsAutocomplete.select', function(event, data){
    $('#nombre_tercero').val(data.item.nombre);
    $('#factura_tercero_msg').show().find('span').text('Tercero seleccionado: ' + data.item.nombre + ' [' + data.item.value + ']');
    $('#factura_tercero_id').val(data.item.id);
  });

  // Cuando cambie el cuit del tercero cuando actualicemos el nombre
  $('#nombre_tercero').bind('railsAutocomplete.select', function(event, data){
    $('#cuit_tercero').val(data.item.cuit);
    $('#factura_tercero_msg').show().find('span').text('Tercero seleccionado: ' + data.item.value + ' [' + data.item.cuit + ']');
    $('#factura_tercero_id').val(data.item.id);
  });

  // Quitar tercero seleccionado
  $('#factura_tercero_clear').on('click',function(e){
    e.preventDefault();
    e.stopPropagation();
    $('#factura_tercero_msg').hide().find('span').text('');
    $('#factura_tercero_id').val('');
    $('#cuit_tercero').val('');
    $('#nombre_tercero').val('');

    return false;
  });



});
