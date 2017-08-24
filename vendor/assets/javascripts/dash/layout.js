$(document).on('click', '.toggle-menu', function(e){
  e.preventDefault();
  var closed = $('#page-nav').width() == 0
  if(closed){
    $('#page-nav').animate({'flex-basis': 250}, 250);
  }else{
    $('#page-nav').animate({'flex-basis': 0}, 250);
  }
})
// $(window).on('resize', function(){
//   console.log('resized');
// })
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
                        html += `
                          <li>
                            <div class="notification-item">
                              <div class="icon">
                                <i class="fa fa-${icon}"></i>
                              </div>
                              <div class="content">
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
$(document).on('turbolinks:load', loadNotifications);

$(document).on('show.bs.dropdown', '.nav-item-notification .dropdown', function(){
  notificationScroller.intialItemLoad();
})
