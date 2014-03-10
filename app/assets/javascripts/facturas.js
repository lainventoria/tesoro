$(document).ready(function(){

// cuando se hace un cambio en IVA o importe neto, calcular el importe
// bruto
  $('#factura_importe_neto').on('keyup', function() {
    $('#factura_importe_total')[0].value = parse_float($('#factura_importe_neto')[0].value) + parse_float($('#factura_iva')[0].value);
  });

  $('#factura_iva').on('keyup', function() {
    $('#factura_importe_total')[0].value = parse_float($('#factura_importe_neto')[0].value) + parse_float($('#factura_iva')[0].value);
  });

// al hacer click en una celda de la tabla, redirige a la vista
// detallada no se puede aplicar al renglon entero porque sobreescribe
// al boton de agregar recibo el id de cada celda de la lista tiene que
// contener el path de destino
  $(document).on('click', '.ir-a', function(e) {
    e.preventDefault();
    window.location.href = $(e.target).data('uri');
    return false;
  });

// script que permite que un boton ubicado fuera del formulario lo
// postee hay que referirse al formulario por su id para el caso de una
// nueva factura el id del formulario es siempre new_factura
  $('#btnGuardar').on('click', function() {
    $('#new_factura').submit();
    $('.edit_factura').submit();
  });
});
