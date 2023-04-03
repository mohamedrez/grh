import { Application } from "@hotwired/stimulus"
import Notification from 'stimulus-notification'
import { Alert, Autosave, Dropdown, Modal, Tabs, Popover, Toggle, Slideover } from "tailwindcss-stimulus-components"

const application = Application.start()

application.register('notification', Notification)
application.register('dropdown', Dropdown)
// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
