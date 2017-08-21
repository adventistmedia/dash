$(document).on('click', '.pop-switcher', function(e){
  e.preventDefault();
  var target = $(this).data('target');
  var menu = $(this).parents('.dropdown-menu');
  menu.find('.pop-content').toggle();
  menu.find(target).toggle();
})
$(document).on('click', '.pop-return', function(e){
  var menu = $(this).parents('.dropdown-menu');
  menu.find('.pop-content').show();
  menu.find('.pop-pane').hide();
})
$(document).on('click', '.nav-popper', function(e){
  e.stopPropagation();
})