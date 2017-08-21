class PopScroller {

  constructor(options) {
    var _this = this;
    this.parent = options.parent;
    this.url = options.url;
    this.currentPage = 0;
    this.lastPage = false;
    this.loadTriggerPos = 150;
    this.loading = false;
    $(this.parent).on('scroll', function(){
      _this.scrollCheck();
    })
    this.loadItems();
  }

  scrollCheck(){
    // get position to bottom
    var scrollHeight = $(this.parent).prop('scrollHeight');
    var scrollTop = $(this.parent).scrollTop();
    var parentHeight = $(this.parent).height();

    var posToBottom = scrollHeight - (scrollTop + parentHeight);
    if(!this.loading && posToBottom < this.loadTriggerPos){
      this.loadItems();
    }
  }

  loadItems(){
    var _this = this;
    this.startLoading();
    var page = this.currentPage + 1;
    $.ajax({
			type: "GET",
			url: this.url,
      dataType: "json",
      data: {
        page: page
      },
      success: function( data ){
        if(data.meta.lastPage){
          _this.allDone();
        }
        _this.currentPage = page;
        _this.populateContent(data.content);
      },
      complete: function(){
        _this.endLoading();
      }
    })
  }

  startLoading(){
    this.loading = true;
    var html = '<div class="loading"><i class="fa fa-spinner fa-spin"></i></div>';
    $(this.parent).append(html);
  }

  endLoading(){
    this.loading = false;
    $(this.parent + ' .loading').remove();
  }

  populateContent(data){
    $(this.parent).append(data);
  }

  allDone(){
    $(this.parent).off('scroll');
  }
};
$(document).ready(function(){
  $('.pop-scroller').each(function(){
    new PopScroller({
      parent: '#'+$(this).attr('id'),
      url: $(this).data('url')
    })
  })
})
