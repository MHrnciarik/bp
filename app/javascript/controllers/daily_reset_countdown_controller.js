import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    format: { type: String, default: "hours" },
    resetAt: String
  }

  connect() {
    this.update()
    this.timer = setInterval(() => this.update(), 30000)
  }

  disconnect() {
    clearInterval(this.timer)
  }

  update() {
    const resetAt = new Date(this.resetAtValue)
    const seconds = Math.max(0, Math.ceil((resetAt - new Date()) / 1000))

    if (this.formatValue === "days") {
      const days = Math.floor(seconds / 86400)
      const hours = Math.floor((seconds % 86400) / 3600)
      const minutes = Math.floor((seconds % 3600) / 60)

      this.element.textContent = `${days}:${this.pad(hours)}:${this.pad(minutes)}`
      return
    }

    const hours = Math.floor(seconds / 3600)
    const minutes = Math.floor((seconds % 3600) / 60)

    this.element.textContent = `${this.pad(hours)}:${this.pad(minutes)}`
  }

  pad(number) {
    return String(number).padStart(2, "0")
  }
}
