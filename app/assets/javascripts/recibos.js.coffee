$(document)
  # FIXME por qué no está largando ajax:success???
  .on 'ajax:complete', '.agregar-movimiento', (xhr, cosas) ->
    $('#nuevo-movimiento').html(cosas.responseText)

    $("#causa_monto_moneda").on "change", ->
      if $("#causa_monto_moneda").val() is $("#selector_moneda").val()
        $("#movimiento_monto_aceptado *").hide()
      else
        $("#movimiento_monto_aceptado *").show()

    $("#causa_monto_moneda").trigger("change")

    # TODO Por alguna razón no bindea a los nuevos objetos
    $('input[data-role=money]').autoNumeric('init')
    $(':enabled .input-group.date').datepicker({
      format: "dd M yyyy",
      weekStart: 1,
      autoclose: true,
      language: "es",
      forceParse: false
    })
