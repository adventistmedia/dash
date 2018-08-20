class PopAutocomplete {

  constructor(options) {
    var _this = this;
    this.form = options.form;
    this.input = $(options.form + ' .search-input');
    this.wrapper = $(options.form).parents('.navbar-search');
    this.url = $(options.form).attr('action');
    this.results = $(options.form).next('.search-results');
    this.cache = {};
    this.minChars = 1;
    this.delay = 250;
    this.lastVal;
    this.timer;
    this.input.on('keyup', function(){
      _this.search();
    })
    this.input.on('keydown', function(e){
      _this.navigate(e);
    })
    $(this.form + ' .search-close').on('click', function(e){
      e.preventDefault();
      _this.input.val('');
      _this.close();
    })
    this.input.on('click', function(e){
      if(!_this.wrapper.hasClass('active')){
        _this.wrapper.addClass('active');
        $(document).on('click.pop-autocomplete', function(e){ _this.outsideClose(e) });
      }
    })

  }

  navigate(e){
    // down (40), up (38)
    var items = this.results.find('li.item');
    if((e.which == 40 || e.which == 38) && items.length > 0){
      var selected = this.results.find('li.item.selected');
      var next;
      if(selected.length == 0){
        next = (e.which == 40) ? items.first() : items.last();
        next.addClass('selected');
      }else{
        next = (e.which == 40) ? selected.next() : selected.prev();
        if(next.length == 0){
          next = (e.which == 40) ? items.first() : items.last();
        }
        selected.removeClass('selected');
        next.addClass('selected');
      }

    }
    // enter (13)
    else if(e.which == 13){
      e.preventDefault();
      var selected = this.results.find('li.item.selected');
      if(selected.length > 0){
        var url = selected.find('a').attr('href');
        window.location.href = url;
      }
    }
    // escape(27)
    else if(e.which == 27){
      this.close();
    }
  }
  // Close based on clicking outside the search wrapper
  outsideClose(e){
    if(!this.wrapper.is(e.target) && this.wrapper.has(e.target).length === 0){
      this.close();
    }
  }

  close(){
    // This needs reworking!
    this.wrapper.removeClass('active');
    this.results.html('');
    this.results.removeClass('active');
    this.input.blur();
    $(document).off('click.pop-autocomplete' );
  }

  search(){
    // get query
    var _this = this;
    var val = $(this.input).val();
    if(val.length >= this.minChars){
      if(val != this.lastVal){
        clearTimeout(this.timer);
        var cacheResult = this.cache[val];
        if(cacheResult){
          this.render(cacheResult);
        }else{
          this.timer = setTimeout(function(){ _this.fetch(val); }, _this.delay);
        }
        this.lastVal = val;
      }
    }
    else{
      this.results.html('');
      this.results.removeClass('active');
    }
  }

  fetch(val){
    var _this = this;
    $.ajax({
			type: "GET",
			url: this.url,
      dataType: "json",
      data: {
        q: val
      },
      success: function( data ){
        _this.cache[val] = data;
        _this.render(data);
      }
    })
  }

  render(data){
    var _this = this;
    var html = '';
    if(data.length > 0){
      data.forEach(function(item) {
        html += _this.renderItem(item);
      })
    }else{
      html = this.noResults();
    }
    this.results.addClass('active');
    this.results.html(html);
  }

  noResults(){
    return '<li class="no-result"><span>No results found.</span></li>';
  }

  renderItem(item){
    var icon = item.icon || 'square-o';
    var description = item.description ? `<span class="description">${item.description}</span>` : '';
    return '<li class="item"><i class="fas fa-'+icon+'"></i> <span><a href="'+item.url+'">'+item.label + description + '</a></span></li>';
  }
}
function loadPopAutocomplete(){
  $('.pop-autocomplete').each(function(){
    new PopAutocomplete({
      form: '#'+$(this).attr('id'),
    })
  })
}
$(document).on('turbolinks:load', loadPopAutocomplete);