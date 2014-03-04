$(document).ready(function(){
// al hacer click en un renglon, redirige a la vista detallada el id de
// cada renglon de la lista tiene que contener el path de destino
  $('tr').on('click', function() { window.location = this.id});
});
