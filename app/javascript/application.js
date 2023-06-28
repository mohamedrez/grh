// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "trix"
import "@rails/actiontext"
import TomSelect from "tom-select";

// import { getUserNavBarNotification } from "./custom.mjs";

// function getCookie(name) {
//   const value = `; ${document.cookie}`;
//   const parts = value.split(`; ${name}=`);
//   if (parts.length === 2) return parts.pop().split(';').shift();
// }

// if (getCookie("user_id") != 'guest') {
//   getUserNavBarNotification();
// }

new TomSelect('#user_job_title',{});
new TomSelect('#user_manager_id',{});
