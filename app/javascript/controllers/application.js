import { Application } from "@hotwired/stimulus"
import Notification from 'stimulus-notification'
import { Alert, Autosave, Dropdown, Tabs, Popover, Toggle, Slideover } from "tailwindcss-stimulus-components"

const application = Application.start()

application.register('notification', Notification)
application.register('dropdown', Dropdown)
application.register('tabs', Tabs)
// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
