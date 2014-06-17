$(document).ready(function(){

  // TERCERO

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

  // UNIDADES

  // Agregar unidad x id
  var agregar_unidad = function(id) {
    $obra = $('input[name=obra_id]');
    $.get('/obras/' + $obra.val() + '/unidades_funcionales/' + id +'.json', function(data) {
      html = '<tr><td>' + data.tipo + ' ' + data.id + '</td>'
      html += '<td>' + data.precio_venta_moneda + '</td>';
      html += '<td><input type="text" data-role="money" name="unidades_funcionales[' + data.id + '][precio_venta]" value="' + data.precio_venta_centavos / 100 + '" class="form-control precio" /></td>';
      html += '<td><a href="#" class="quitar-unidad"><span class="glyphicon glyphicon-remove-circle text-danger"></span></a></td></tr>';
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
  $('#contrato_de_venta_unidades_funcionales_table').on('click','.quitar-unidad',function(e){
    $t = $(e.target);
    $t.closest('tr').remove();
    actualizar_total();
  });

  // Agregar unidad seleccionada
  $('#contrato_de_venta_unidad_funcional_agregar').on('click',function(e){
    unidad_id = $('#contrato_de_venta_unidades_funcionales').val();
    agregar_unidad(unidad_id);
    $('#contrato_de_venta_unidades_funcionales option:selected').remove();
  });


  // CUOTAS

  var agregar_cuota = function(fecha, monto) {
    html = '<tr><td>' + $.datepicker.formatDate('dd M yy', fecha) + '</td><td>' + monto + '</td>';
    html += '<td><a href="#" class="quitar-cuota"><span class="glyphicon glyphicon-remove-circle text-danger"></span></a></td></tr>';
    $('#contrato_de_venta_cuotas_table').append(html);
  }

  var generar_cuotas = function() {
    total = $('#contrato_de_venta_total').autoNumeric('get');
    pago_inicial = $('#contrato_de_venta_pago_inicial').autoNumeric('get');
    a_financiar = total - pago_inicial;

    cantidad_de_cuotas = $('#contrato_de_venta_cantidad_cuotas').val();
    monto_cuota = Math.floor( a_financiar / cantidad_de_cuotas );
    resto = a_financiar - (monto_cuota * cantidad_de_cuotas);

    primera_cuota = new Date( $('#contrato_de_venta_fecha_primera_cuota').val() );
    periodicidad = $('#contrato_de_venta_periodicidad_cuotas').val();

    for ( i=1; i <= cantidad_de_cuotas; i++ ) {
      t_monto = monto_cuota;
      if ( i == 1 ) {
        t_monto += resto;
      }
      mes = primera_cuota.getMonth() + ( i - 1) * periodicidad;
      ano = primera_cuota.getFullYear();
      while ( mes > 12 ) {
        mes -= 12;
        ano += 1;
      }
      t_fecha = new Date(ano,mes,primera_cuota.getDate());

      agregar_cuota(t_fecha,t_monto);
    }
  }


  $('#contrato_de_venta_generar_cuotas').on('click',function(e){
    e.preventDefault();
    $('#contrato_de_venta_cuotas_table').html('')
    generar_cuotas();
  });
 
  $('#contrato_de_venta_cuotas_table').on('click','.quitar-cuota',function(e){
    $t = $(e.target);
    $t.closest('tr').remove();
  });

});
