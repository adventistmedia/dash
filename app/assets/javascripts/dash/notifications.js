$(document).on('click', '.clear-notifications', function(e){
  e.preventDefault();
  var menu = $(this).parents('.dropdown-menu');
  $.ajax({
    type: "POST",
    url: $(this).attr('href'),
    dataType: "script",
    success: function( data ){
      notificationScroller.reload();
      menu.find('.pop-content').show();
      menu.find('.pop-pane').hide();
    }
  })
})