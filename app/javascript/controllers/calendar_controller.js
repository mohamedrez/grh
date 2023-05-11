import { Controller } from "@hotwired/stimulus"
import { Calendar } from '@fullcalendar/core';
import dayGridPlugin from '@fullcalendar/daygrid';
import timeGridPlugin from '@fullcalendar/timegrid';
import listPlugin from '@fullcalendar/list';

// Connects to data-controller="calendar"

function fetchUrlWithCurrentQueryParams(){
  var url = new URL(window.location.href);
  var params = new URLSearchParams(url.search);
  return 'events.json' + "?" + params.toString();
}
function eventHtml(event) {
  var content = '';
  if (event.extendedProps.avatar){
    console.log(event.extendedProps.avatar)
    content += '<img class="inline-block rounded-full h-8 w-8 align-middle" src="'+ event.extendedProps.avatar +'">'
  }
  content += '<span class="ml-2">' + event.title   + '</span>';
  return '<div class="">'+ content +'</div>';
}
function  renderCalendar(events){
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
      return {html: eventHtml(info.event)};
    },
  }
  );
  calendar.render();
}
export default class extends Controller {

  connect() {
    fetch(fetchUrlWithCurrentQueryParams())
      .then(function(response) {
        return response.json();
      })
      .then(function(events) {
        renderCalendar(events);
      });
  }
}
