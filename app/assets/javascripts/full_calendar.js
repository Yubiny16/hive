
var initialize_calendar;
initialize_calendar = function() {
  $('.calendar').each(function(){
    var calendar = $(this);
    //var current_groupuser_admin = document.getElementById("current_groupuser_admin").innerHTML;
    var current_groupuser_admin = "false";
    var x = "false";
    if(current_groupuser_admin === "true" )
    {
      x = "true";
    }
    else {
      x = "false";
    }
    calendar.fullCalendar({
      header: {
        left: 'prev, next, today',
        center: 'title',
        right: 'month, agendaWeek, agendaDay'
      },
      selectable: x,
      selectHelper: x,
      editable: x,
      eventLimit: x,
      events: '/events.json',
      select: function(start, end) {
        $.getScript('/events/new', function() {
          $('#event_date_range').val(moment(start).format("MM/DD/YYYY HH:mm") + ' - ' + moment(end).format("MM/DD/YYYY HH:mm"));
          date_range_picker();
          $('.start_hidden').val(moment(start).format('YYYY-MM-DD HH:mm'));
          $('.end_hidden').val(moment(end).format('YYYY-MM-DD HH:mm'));

        });
        calendar.fullCalendar('unselect');
      },
      eventDrop: function(event, delta, revertFunc) {
      event_data = {
        event: {
          id: event.id,
          start: event.start.format(),
          end: event.end.format()
        }
      };
      $.ajax({
            url: event.update_url,
            data: event_data,
            type: 'PATCH'
        });
      },
      eventClick: function(event, jsEvent, view) {
     $.getScript(event.edit_url, function() {
       $('#event_date_range').val(moment(event.start).format("MM/DD/YYYY HH:mm") + ' - ' + moment(event.end).format("MM/DD/YYYY HH:mm"));
       date_range_picker();
       $('.start_hidden').val(moment(event.start).format('YYYY-MM-DD HH:mm'));
       $('.end_hidden').val(moment(event.end).format('YYYY-MM-DD HH:mm'));
     });
   }
    });
  });
};
$(document).on('turbolinks:load', initialize_calendar);
