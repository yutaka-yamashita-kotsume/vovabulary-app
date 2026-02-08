import "@hotwired/turbo-rails"
import "controllers"

// 念のためTurboをグローバルに公開（エラー回避用）
import { Turbo } from "@hotwired/turbo-rails"
window.Turbo = Turbo