$(document).on("keyup", ".list-filter", function(e){
  var target = $(this).data("target");
  var term = $(this).val().trim().toLowerCase();
  if(term == ""){
    $(target).show();
  }else{
    $(target).each(function(i, el){
      if($(el).data("filter").indexOf(term) >= 0){
        $(el).show();
      }else{
        $(el).hide();
      }
    })
  }
})