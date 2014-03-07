function parse_float (s){
  return parseFloat (s.replace(/,/,'.'));
};

$(document).ready(function(){
// Inicializar los datepicker
  $('.input-group.date').datepicker({
    format: "dd M yyyy",
    weekStart: 1,
    autoclose: true,
    language: "es",
    forceParse: false
  });
});
