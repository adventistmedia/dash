function loadSnackbar(){
  var snackbar = $('.snackbar');
  var delayTime = 250;
  var showTime = 3000;
  if(snackbar) {
    // delay adding so we can see show effect
    setTimeout(function(){
      snackbar.slideToggle();
    }, delayTime);
    setTimeout(function(){
      snackbar.slideToggle(function(){
        snackbar.remove();
      });
    }, delayTime + showTime);
  }
}
$(document).on('turbolinks:load', loadSnackbar);