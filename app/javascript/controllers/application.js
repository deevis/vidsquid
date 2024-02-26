import { Application } from "@hotwired/stimulus"

console.log("Hello from javascript/controllers/application.js");

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }