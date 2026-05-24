import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "company", "mode", "option", "person" ]

  connect() {
    this.update()
  }

  update() {
    const kind = this.modeTargets.find((field) => field.checked)?.value || "company"

    this.toggleGroup(this.companyTargets, kind !== "company")
    this.toggleGroup(this.personTargets, kind !== "person")
    this.optionTargets.forEach((element) => {
      const active = element.dataset.clientKindModeValue === kind

      element.classList.toggle("btn-primary", active)
      element.classList.toggle("btn-soft", !active)
    })
  }

  toggleGroup(elements, hidden) {
    elements.forEach((element) => {
      element.classList.toggle("hidden", hidden)
      element.querySelectorAll("input, select, textarea").forEach((field) => {
        field.disabled = hidden
      })
    })
  }
}
