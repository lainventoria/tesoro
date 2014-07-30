$(document).ready(function(){

  // TERCERO

  if ( $('#contrato_de_venta_tercero_id').val() > 0  && !$('#contrato_de_venta_tercero_attributes_nombre').closest('fieldset').is('[disabled]') ) {
    $('#contrato_de_venta_tercero_msg').show().find('span').text('Tercero seleccionado: ' + $('#contrato_de_venta_tercero_attributes_nombre').val() + ' [' + $('#contrato_de_venta_tercero_attributes_cuit').val() + ']');
  }

  // Cambiar el nombre del tercero cuando actualicemos el cuit
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
    $obra = $('#contrato_de_venta_obra_id');
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

  $('input[data-role=money]').autoNumeric('init');
  actualizar_total();

  // CUOTAS
  var agregar_cuota = function( fecha_ , monto_ ) {
    html = '<tr><td>' + $.datepicker.formatDate('dd M yy', fecha_ ) + '</td><td>' + monto_;
    html += '<input type="hidden" name="fechas[]" value="' + fecha_.toString() + '" />';
    html += '<input type="hidden" name="montos[]" class="monto" value="' + monto_ + '" /></td>';
    html += '<td><a href="#" class="quitar-cuota"><span class="glyphicon glyphicon-remove-circle text-danger"></span></a></td></tr>';
    $('#contrato_de_venta_cuotas_table').append(html);
    actualizar_total_cuotas();
  }

  var actualizar_total_cuotas = function() {
    var sum = 0;
    $('.monto').each(function(){
      sum += Number($(this).val());
    });
      
    $('#cuotas_total').autoNumeric('set',sum);

    if ( $('#cuotas_total').autoNumeric('get') != $('#contrato_de_venta_total').autoNumeric('get') ) {
      $('#cuotas_total').addClass('error');
    } else {
      $('#cuotas_total').removeClass('error');
    }
  }

  var generar_cuotas = function() {
    total = $('#contrato_de_venta_total').autoNumeric('get');

    cantidad_de_cuotas = $('#contrato_de_venta_cantidad_cuotas').val();
    monto_cuota = $('#contrato_de_venta_monto_cuotas').autoNumeric('get');

    primera_cuota = parseDate( $('#contrato_de_venta_fecha_primera_cuota').val() );
    periodicidad = $('#contrato_de_venta_periodicidad_cuotas').val();

    // Recorro las cuotas generando cada una
    for ( i=1; i <= cantidad_de_cuotas; i++ ) {
      mes = primera_cuota.getMonth() + ( i - 1) * periodicidad;
      ano = primera_cuota.getFullYear();
      while ( mes > 12 ) {
        mes -= 12;
        ano += 1;
      }
      t_fecha = new Date(ano,mes,primera_cuota.getDate());
      agregar_cuota(t_fecha,monto_cuota);
    }
  }

  // Generar cuotas click
  $('#contrato_de_venta_generar_cuotas').on('click',function(e){
    e.preventDefault();
    $('#contrato_de_venta_cuotas_table').html('')
    generar_cuotas();
  });
 
  // Quitar cuota click
  $('#contrato_de_venta_cuotas_table').on('click','.quitar-cuota',function(e){
    $t = $(e.target);
    $t.closest('tr').remove();
    actualizar_total_cuotas();
  });

  // Agregar cuota click
  $('#contrato_de_venta_agregar_cuota').on('click',function(e){ 
    e.preventDefault();
    fecha = parseDate( $('#contrato_de_venta_fecha_cuota').val() );
    mon = $('#contrato_de_venta_monto_cuota').autoNumeric('get');
    agregar_cuota(fecha,mon);
  });

  // No poder guardar si no cierran los totales
  $('#new_contrato_de_venta').on('submit',function(e){
    if ( $('#cuotas_total').autoNumeric('get') != $('#contrato_de_venta_total').autoNumeric('get') ) {
      e.preventDefault();
      e.stopPropagation();
    }
  });

});
