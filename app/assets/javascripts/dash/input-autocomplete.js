class InputAutocomplete {

  constructor(input, options) {
    var _this = this;
    this.input = input;
    this.url = input.data("url");
    this.results = $("#" + input.attr("id") + "-results");
    this.cache = {};
    this.minChars = 1;
    this.delay = 250;
    this.lastVal;
    this.noResultsText = input.data("noResultsText") || "No results found.";
    this.noResultsCallback = input.data("noResultsCallback");
    this.timer;
    this.input.on('keyup', function(){
      _this.search();
    })
    this.input.on('keydown', function(e){
      _this.navigate(e);
    })
    $(document).on("click", ".ia-item", function(e){
      e.preventDefault();
      _this.itemSelected(this);
    })
  }

  navigate(e){
    // down (40), up (38)
    var items = this.results.find('li.ia-item');
    if((e.which == 40 || e.which == 38) && items.length > 0){
      var selected = this.results.find('li.ia-item.selected');
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
      var selected = this.results.find('li.ia-item.selected');
      if(selected.length > 0){
        this.itemSelected(selected);
      }
    }
    // escape(27)
    else if(e.which == 27){
      this.close();
    }
  }

  close(){
    // This needs reworking!
    this.results.html('');
    this.results.removeClass('active');
    $(document).off('click.input-autocomplete' );
  }

  // Close based on clicking outside the search wrapper
  outsideClose(e){
    if(!this.input.is(e.target) && !this.results.is(e.target) && this.results.has(e.target).length === 0){
      this.close();
    }
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
    $(document).on('click.input-autocomplete', function(e){ _this.outsideClose(e) });
  }

  noResults(){
    var noResultText = this.noResultsCallback ? `<a href=''>${this.noResultsText}</a>` : this.noResultsText;
    return `<li class="no-result"><span>${noResultText}</span></li>`;
  }

  renderItem(item){
    var logo;
    if(item.image){
      logo = `<img src="${item.image}"/>`;
    }else{
      var icon = item.icon || 'square-o';
      logo = `<i class="fas fa-${icon}"></i>`;
    }
    var label = item.label;
    if(item.subtitle){
      label += "<span class='subtitle'>"+item.subtitle+"</span>";
    }

    return `
      <li class="ia-item" data-value="${item.value}" data-label="${item.label}" data-url="${item.url}">
        <div class="logo">${logo}</div>
        <div class="content">
          <a href="#" class="ia-link">${label}</a>
        </div>
      </li>`;
  }

  itemSelected(item){
    var target = this.input.data("target");
    var url = $(item).data("url");
    this.input.blur();
    this.input.val( $(item).data("label") );
    if(target){
      $(target).val( $(item).data("value") );
      // submit parent form and clear form
      if(this.input.data("submit") == 1){
        $(target).parents("form").submit();
        this.input.val("");
      }
    }else if(url){
      window.location.href = url;
    }
    this.close();
  }

}
function loadInputAutocomplete(){
  $('.input-autocomplete').each(function(){
    new InputAutocomplete($(this), {})
  })
}
$(document).on('turbolinks:load', loadInputAutocomplete);