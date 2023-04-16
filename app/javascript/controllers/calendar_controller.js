import { Controller } from "@hotwired/stimulus"
import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import timeGridPlugin from '@fullcalendar/timegrid';
import listPlugin from '@fullcalendar/list';

// Connects to data-controller="calendar"
function  eventHtml(event) {
  var content = '<img class="inline-block rounded-full h-8 w-8 align-middle" src="'+ event.avatar +'">'
  content += '<span class="ml-2">' + event.user + '</span>';
  return content;
}
function   renderCalendar(events){
  var calendarEl = document.getElementById('calendar');
  var calendar = new Calendar(
    calendarEl, {
    plugins: [dayGridPlugin, timeGridPlugin, listPlugin],
    headerToolbar: {
      left: 'prev,next today',
      center: 'title',
      right: 'dayGridMonth,timeGridWeek,listWeek'
    },
    initialView: 'dayGridMonth',
    events: events,
    eventContent: function( info ) {
      return {html: eventHtml(info.event.extendedProps)};
    },
  }
  );
  calendar.render();
}
export default class extends Controller {

  connect() {
    fetch('/events.json')
      .then(function(response) {
        return response.json();
      })
      .then(function(events) {
        renderCalendar(events);
      });
  }
}
