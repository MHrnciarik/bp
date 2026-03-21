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
    "subtotal",
    "taxRate",
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
    let subtotal = 0

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

      subtotal += lineTotal
    })

    const taxRate = this.#taxRate()
    const total = subtotal * (1 + taxRate / 100)

    if (this.hasSubtotalTarget) {
      this.subtotalTarget.textContent = this.#format(subtotal)
    }

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

  #taxRate() {
    if (!this.hasTaxRateTarget) {
      return 0
    }

    const value = Number.parseFloat(this.taxRateTarget.value || "")
    return Number.isFinite(value) ? value : 0
  }
}
