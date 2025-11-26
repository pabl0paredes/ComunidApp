# # Pin npm packages by running ./bin/importmap

# pin "application"
# pin "@hotwired/turbo-rails", to: "turbo.min.js"
# pin "@hotwired/stimulus", to: "stimulus.min.js"
# pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
# pin_all_from "app/javascript/controllers", under: "controllers"
# pin "bootstrap", to: "bootstrap.min.js", preload: true
# pin "@popperjs/core", to: "popper.js", preload: true
# pin "flatpickr" # @4.6.13


pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
pin "flatpickr", to: "https://ga.jspm.io/npm:flatpickr@4.6.13/dist/esm/index.js", preload: true
# Flatpickr JS y CSS desde CDN
# pin "flatpickr" # @4.6.13
# pin "flatpickr/dist/flatpickr.min.css", to: "https://ga.jspm.io/npm:flatpickr@4.6.13/dist/flatpickr.min.css"
# pin "flatpickr/dist/themes/material_blue.css", to: "https://ga.jspm.io/npm:flatpickr@4.6.13/dist/themes/material_blue.css"
