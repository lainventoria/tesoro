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

  // Agregar unidad x id
  var agregar_unidad = function(id) {
    $obra = $('input[name=obra_id]');
    $.get('/obras/' + $obra.val() + '/unidades_funcionales/' + id +'.json', function(data) {
      html = '<tr><td>' + data.tipo + ' ' + data.id + '</td>'
      html += '<td>' + data.precio_venta_moneda + '</td>';
      html += '<td><input type="text" data-role="money" name="unidades_funcionales[' + data.id + '][precio_venta]" value="' + data.precio_venta_centavos / 100 + '" class="form-control precio" /></td><td></td></tr>';
      $('#contrato_de_venta_unidades_funcionales_table').append(html);

      $('input[data-role=money]').autoNumeric('init');
      actualizar_total();

    }, 'json');
  }


  var actualizar_total = function() {
    var sum = 0;
    $('.precio').each(function(){
      sum += Number($(this).autoNumeric('get'));
    });
    $('#contrato_de_venta_total').autoNumeric('set',sum);
  }

  $('#contrato_de_venta_unidades_funcionales_table').on('keyup','.precio',actualizar_total);

  // Agregar unidad seleccionada
  $('#contrato_de_venta_unidad_funcional_agregar').on('click',function(e){
    unidad_id = $('#contrato_de_venta_unidades_funcionales').val();
    agregar_unidad(unidad_id);
    $('#contrato_de_venta_unidades_funcionales option:selected').remove();
  });

});
