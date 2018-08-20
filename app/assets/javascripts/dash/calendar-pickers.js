function calendarPickers() {
  var datetimeIcons = {
    time: "fas fa-clock",
    date: "fas fa-calendar-alt",
    up: "fas fa-arrow-up",
    down: "fas fa-arrow-down",
    previous: "fas fa-chevron-left",
    next: "fas fa-chevron-right",
    today: "fas fa-dot-circle",
    clear: "fas fa-trash-alt",
    close: "fas fa-times"
  }
  // date time picker
  $.each( $(".datepicker"), function(i,item){
    options = {
      format: "YYYY/MM/DD",
      icons: datetimeIcons
    };
    data = $(item).data() || {};
    if ( data.maxDate != undefined ){
      options['maxDate'] = data.maxDate;
    }
    if ( data.minDate != undefined){
      options['minDate'] = data.minDate;
    }
    $(item).datetimepicker(options);
  })

  $.each( $(".datetimepicker"), function(i,item){
    options = {
      stepping: 5,
      format: "YYYY/MM/DD hh:mm A",
      icons: datetimeIcons
    };
    $(item).datetimepicker(options);
  })

  $.each( $(".timepicker"), function(i,item){
    options = {
      stepping: 5,
      format: "hh:mm A",
      icons: datetimeIcons
    };
    $(item).datetimepicker(options);
  })

}
$(document).on('turbolinks:load', calendarPickers);