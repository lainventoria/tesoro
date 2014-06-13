$(document).ready(function(){

  // Cuando cambie el nombre del tercero cuando actualicemos el cuit
  $('#contrato_de_venta_tercero_attributes_cuit').on('railsAutocomplete.select', function(event, data){
    $('#contrato_de_venta_tercero_attributes_nombre').val(data.item.nombre);
    $('#contrato_de_venta_tercero_msg').show().find('span').text('Tercero seleccionado: ' + data.item.nombre + ' [' + data.item.value + ']');
    $('#contrato_de_venta_tercero_id').val(data.item.id);
  });

  // Cuando cambie el cuit del tercero cuando actualicemos el nombre
  $('#contrato_de_venta_tercero_attributes_nombre').on('railsAutocomplete.select', function(event, data){
    $('#contrato_de_venta_tercero_attributes_cuit').val(data.item.cuit);
    $('#contrato_de_venta_tercero_msg').show().find('span').text('Tercero seleccionado: ' + data.item.value + ' [' + data.item.cuit + ']');
    $('#contrato_de_venta_tercero_id').val(data.item.id);
  });

  // Quitar tercero seleccionado
  $('#contrato_de_venta_tercero_clear').on('click',function(e){
    e.preventDefault();
    e.stopPropagation();
    $('#contrato_de_venta_tercero_msg').hide().find('span').text('');
    $('#contrato_de_venta_tercero_id').val('');
    $('#contrato_de_venta_tercero_attributes_cuit').val('');
    $('#contrato_de_venta_tercero_attributes_nombre').val('');

    return false;
  });



});
