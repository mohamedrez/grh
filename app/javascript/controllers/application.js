import { Application } from "@hotwired/stimulus"
import Notification from 'stimulus-notification'
import { Alert, Autosave, Dropdown, Modal, Tabs, Popover, Toggle, Slideover } from "tailwindcss-stimulus-components"

const application = Application.start()

application.register('notification', Notification)
application.register('alert', Alert)
application.register('autosave', Autosave)
application.register('dropdown', Dropdown)
application.register('modal', Modal)
application.register('tabs', Tabs)
application.register('popover', Popover)
application.register('toggle', Toggle)
application.register('slideover', Slideover)
// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
