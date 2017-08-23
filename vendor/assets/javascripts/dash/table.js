$(document).on('click', 'tr[data-url] td:not(:last-child)', function(){
  window.location = $(this).parents('tr').data('url');
})