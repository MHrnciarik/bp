import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "currencyLabel",
    "currencySelect",
    "destroyField",
    "items",
    "lineTotal",
    "price",
    "quantity",
    "row",
    "template",
    "total"
  ]

  connect() {
    this.updateCurrency()
    this.updateTotals()
  }

  addRow() {
    const content = this.templateTarget.innerHTML.replaceAll("NEW_RECORD", Date.now().toString())
    this.itemsTarget.insertAdjacentHTML("beforeend", content)
    this.updateTotals()
  }

  removeRow(event) {
    const row = event.target.closest("tr")
    const destroyField = row.querySelector("input[name*='[_destroy]']")
    const idField = row.querySelector("input[name*='[id]']")

    if (idField) {
      destroyField.value = "1"
      row.classList.add("hidden")
    } else {
      row.remove()
    }

    this.updateTotals()
  }

  updateCurrency() {
    this.currencyLabelTarget.textContent = this.currencySelectTarget.value || ""
  }

  updateTotals() {
    let total = 0

    this.rowTargets.forEach((row) => {
      if (row.classList.contains("hidden")) {
        return
      }

      const quantity = this.#numberValue(row, "quantity")
      const price = this.#numberValue(row, "price")
      const lineTotal = quantity * price
      const lineTotalElement = row.querySelector("[data-expense-items-target='lineTotal']")

      if (lineTotalElement) {
        lineTotalElement.textContent = this.#format(lineTotal)
      }

      total += lineTotal
    })

    this.totalTarget.textContent = this.#format(total)
  }

  #numberValue(row, targetName) {
    const field = row.querySelector(`[data-expense-items-target='${targetName}']`)
    const value = Number.parseFloat(field?.value || "")

    return Number.isFinite(value) ? value : 0
  }

  #format(value) {
    return value.toFixed(2)
  }
}
