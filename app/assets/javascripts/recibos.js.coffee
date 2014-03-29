$(document)
  # FIXME por qué no está largando ajax:success???
  .on 'ajax:complete', '.agregar-movimiento', (xhr, cosas) ->
    $('#nuevo-movimiento').html(cosas.responseText)
