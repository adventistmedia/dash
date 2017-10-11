$(document).on('click', '.toggle-menu', function(e){
  e.preventDefault();
  var closed = $('#page-nav').width() == 0;
  if(closed){
    $('#page-nav').animate({'flex-basis': 250}, 250);
  }else{
    $('#page-nav').animate({'flex-basis': 0}, 250);
  }
})
$(document).on('click', '.nav-group-item.expandable', function(e){
  e.preventDefault();
  $(this).parents('li').toggleClass('active');
})
$(document).on('click', '.team-toggle', function(e){
  e.preventDefault();
  $(this).parents('.team-nav').toggleClass('active');
})

//Notifications
var notificationScroller;
function loadNotifications(){
  notificationScroller = new PopScroller({
                    parent: '#notification-list',
                    renderContent: function(data){
                      var html = '';
                      if(data.length == 0){
                        html += `<li><div class="notifications-empty">No news is good news.</div></li>`
                        return html;
                      }
                      $.each(data, function(i, item){
                        var icon = item.icon || 'paper-plane';
                        var subtitle = item.subtitle ? '<span class="subtitle">'+item.subtitle+'</span>' : '';
                        var links = '';
                        $.each(item.links, function(i, link){
                          links += `<a href="${link.url}" class="btn btn-primary btn-sm">${link.name}</a>`;
                        })
                        if(links){
                          links = `<div class="links">${links}</div>`;
                        }
                        var unread = '';
                        if(!item.read){
                          unread = `<div class="unread"><i class="fa fa-circle"></i></div>`;
                        }
                        html += `
                          <li>
                            <div class="notification-item">
                              <div class="icon">
                                <i class="fa fa-${icon}"></i>
                              </div>
                              <div class="content">
                                ${unread}
                                <h5>${item.title}</h5>
                                ${subtitle}
                                <p>${item.description}</p>
                                ${links}
                              </div>
                            </div>
                          </li>`;
                      })
                      return html;
                    }
  })
}
function loadLightbox() {
  $('.lightbox-iframe').fancybox({
    type: 'iframe',
  	toolbar: true,
    buttons: ['close'],
  	smallBtn: false,
  	iframe: {
  		preload: false
  	},
    afterClose: function (instance) {
      if(instance.$lastFocus.hasClass("lightbox-reload")){
        parent.location.reload(true);
      }
    }
  })
}

$(document).on('turbolinks:load', loadLightbox);
$(document).on('turbolinks:load', loadNotifications);

$(document).on('click', '.lightbox-close', function(e){
  e.preventDefault();
  window.parent.$.fancybox.close();
})
$(document).on('show.bs.dropdown', '.nav-item-notification .dropdown', function(){
  notificationScroller.intialItemLoad();
})