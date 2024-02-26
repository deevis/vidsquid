// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
console.log("Hello from javascript/application.js");

import "@hotwired/turbo-rails"
import "./controllers"
// import "trix"
// import "@rails/actiontext"
import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()

