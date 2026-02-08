pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true

# フォルダごとピン留めする設定を以下に変更
pin_all_from "app/javascript/controllers", under: "controllers", to: "controllers"