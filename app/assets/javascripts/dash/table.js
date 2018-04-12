$(document).on('click', 'tr[data-url] td:not(.bulk-selector-item):not(:last-child):not(a)', function(){
  var url = $(this).parents('tr').data('url');
  var lightbox = $(this).parents('tr').data('lightbox');
  if(lightbox){
    $.fancybox.open({
      type: 'iframe',
      src: url,
    	toolbar: true,
    	smallBtn: false,
    	iframe: {
    		preload: false
    	},
      afterClose: function (instance) {
        if(instance.$lastFocus.hasClass("lightbox-reload")){
          parent.location.reload(true);
        }
      }
    });
  }else{
    window.location = url;
  }
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
  updateBulkTogglePane();
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

function updateBulkTogglePane(){
  var numSelected = $('.bulk-selector-item input:checked').length;
  $('#table-bulk-options.active').length == 1;
  $('#items-selected').html(numSelected);
  if(numSelected == 0){
    $('#table-bulk-options').removeClass('active');
  }else{
    $('#table-bulk-options').addClass('active');
  }
}

$(document).on('click', '.table-batch-submit', function(e){
  e.preventDefault();
  var ids = $('.bulk-selector-item input:checked').map(function(){ return $(this).val() }).get();
  $(this).parents('.modal').find('.batch-ids').val(ids);
  $(this).parents('.modal').find('form').submit();
  (this).prop('disabled', true);
})

// Table Filters
$(document).on('click', '.table-filters-toggle', function(e){
  e.preventDefault();
  $('.table-filters').slideToggle().toggleClass('active');
  $(this).toggleClass('active');
})
// Table Search
$(document).on('click', '.table-search:not(.active) .search-btn', function(e){
  e.preventDefault();
  $('.table-search').addClass('active');
  $('.table-header').addClass('focus-search');
  $('.search-input').focus();
})
$(document).on('click', '.table-search .search-close', function(e){
  if( $(this).data('reload') == '0' ){
    e.preventDefault();
    $('.table-search').removeClass('active');
    $('.table-header').removeClass('focus-search');
  }
  $('.table-search .search-input').val('');
})