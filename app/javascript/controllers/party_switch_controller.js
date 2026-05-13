import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "manual", "mode", "option", "saved" ]

  connect() {
    this.update()
  }

  update() {
    const mode = this.modeTargets.find((field) => field.checked)?.value || "manual"

    this.savedTargets.forEach((element) => element.classList.toggle("hidden", mode !== "saved"))
    this.manualTargets.forEach((element) => element.classList.toggle("hidden", mode !== "manual"))
    this.optionTargets.forEach((element) => {
      const active = element.dataset.partySwitchModeValue === mode

      element.classList.toggle("btn-primary", active)
      element.classList.toggle("btn-soft", !active)
    })
  }
}
