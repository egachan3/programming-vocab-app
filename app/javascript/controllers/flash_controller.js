import { Controller } from "@hotwired/stimulus"

// フラッシュメッセージを一定時間後に自動で消す
export default class extends Controller {
  static values = { delay: { type: Number, default: 3000 } }

  connect() {
    this.timer = setTimeout(() => this.dismiss(), this.delayValue)
  }

  disconnect() {
    clearTimeout(this.timer)
  }

  dismiss() {
    this.element.classList.add("opacity-0", "transition-opacity", "duration-500")
    setTimeout(() => this.element.remove(), 500)
  }
}
