class PopScroller {

  constructor(options) {
    var _this = this;
    this.parent = options.parent;
    this.url = $(options.parent).data('url');
    this.currentPage = 0;
    this.lastPage = false;
    this.loadTriggerPos = 150;
    this.loading = false;
    this.initialLoad = false;
    this.renderContent = options.renderContent;
    $(this.parent).on('scroll', function(){
      _this.scrollCheck();
    })

  }

  reset(){
    this.currentPage = 0;
    this.lastPage = false;
    this.initialLoad = false;
    $(this.parent).html("");
  }

  reload(){
    this.reset();
    this.intialItemLoad();
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

  intialItemLoad(){
    if(!this.initialLoad){
      this.loadItems();
      this.initialLoad = true;
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
        $(_this.parent).append( _this.renderContent(data.data) );
      },
      complete: function(){
        _this.endLoading();
      }
    })
  }

  startLoading(){
    this.loading = true;
    var html = '<div class="loading"><i class="fas fa-spinner fa-spin"></i></div>';
    $(this.parent).append(html);
  }

  endLoading(){
    this.loading = false;
    $(this.parent + ' .loading').remove();
  }

  allDone(){
    $(this.parent).off('scroll');
  }
};