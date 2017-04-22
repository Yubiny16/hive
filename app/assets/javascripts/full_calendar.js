var initialize_calendar;
initialize_calendar = function() {
  $('.calendar').each(function(){
    var calendar = $(this);
    calendar.fullCalendar({
      header: {
        left: 'prev, next, today',
        center: 'title',
        right: 'month, agendaWeek, agendaDay'
      },
      selectable: true,
      selectHelper: true,
      editable: true,
      eventLimit: true,

      select: function(start, end) {
        $.getScript('/events/new', function() {});

        calendar.fullCalendar('unselect');
      },
    });
  });
};
$(document).on('turbolinks:load', initialize_calendar);
