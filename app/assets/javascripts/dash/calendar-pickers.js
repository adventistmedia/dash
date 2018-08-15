function calendarPickers() {
  var datetimeIcons = {
    time: "fa fa-clock-o",
    date: "fa fa-calendar",
    up: "fa fa-arrow-up",
    down: "fa fa-arrow-down",
    previous: "fa fa-chevron-left",
    next: "fa fa-chevron-right",
    today: 'fa fa-dot-circle-o',
    clear: 'fa fa-trash',
    close: 'fa fa-close'
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