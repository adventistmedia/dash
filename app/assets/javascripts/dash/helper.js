// Toggle div on and off
$(document).on('click', '[data-toggler]', function(e){
  e.preventDefault();
  $( $(this).data('toggler') ).toggle();
})

// Boolean Toggler
$(document).on('change', '[data-boolean-toggler]', function(){
  var target = $(this).data('booleanToggler');
  $(target).slideToggle();
})

// Toggle elements based on select tag
// <select data-select-toggler=".group"><option value="one"></option>...
//<div class="group group-one">..</div>
function selectToggler(el){
  var selected = $(el).val();
  var target = $(el).data('selectToggler');
  $(target).hide();
  $(target+'-'+selected).show();
}
$(document).on('turbolinks:load', function(){
  $('[data-select-toggler]').each(function(){ selectToggler(this) });
});
$(document).on('change', '[data-select-toggler]', function(){ selectToggler(this) })