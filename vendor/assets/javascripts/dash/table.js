$(document).on('click', 'tr[data-url] td:not(.bulk-selector-item):not(:last-child):not(a)', function(){
  window.location = $(this).parents('tr').data('url');
})

$(document).on('show.bs.modal', '#tableAboutModal', function (e) {
  var btn = $(e.relatedTarget);
  $(this).find('.modal-title').html( btn.data('title') )
  $(this).find('.modal-body').html('<div class="modal-loading"><i class="fa fa-spinner fa-spin"></i></div>');
  $.ajax({
    type: 'GET',
    url: btn.attr('href'),
    dataType: 'script',
    success: function( data ){
      $(this).find('.modal-body').html(data);
    },
    complete: function(){
      $(this).find('.modal-body').html('');
    }
  })
})

$(document).on('click', '.bulk-selector-toggle', function(e){
  e.preventDefault();
  var input = $(this).find('input');
  if( input.prop('checked') ){
    $(this).find('i').removeClass('fa-check-square').addClass('fa-square-o');
    input.prop('checked', false);
  }else{
    $(this).find('i').removeClass('fa-square-o').addClass('fa-check-square');
    input.prop('checked', true);
  }
  if( $(this).hasClass('bulk-selector-all') ){
    bulkToggleAll( input.prop('checked') );
  }
})

function bulkToggleAll(selected){
  if(selected){
    $('.bulk-selector-item i').removeClass('fa-square-o').addClass('fa-check-square');
    $('.bulk-selector-item input').prop('checked', true);
  }else{
    $('.bulk-selector-item i').addClass('fa-square-o').removeClass('fa-check-square');
    $('.bulk-selector-item input').prop('checked', false);
  }
}