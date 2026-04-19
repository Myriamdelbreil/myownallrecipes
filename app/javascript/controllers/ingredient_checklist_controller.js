import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["unchecked", "checked", "emptyState", "allCheckedState", "item"]

  toggle(event) {
    const item = event.currentTarget
    const isChecked = this.checkedTarget.contains(item)
    const name = item.querySelector(".ingredient-name")
    if (isChecked) {
      this.uncheckedTarget.appendChild(item)
      item.querySelector("input[type=checkbox]").checked = false
      name.classList.remove("text-decoration-line-through")
    } else {
      this.checkedTarget.appendChild(item)
      item.querySelector("input[type=checkbox]").checked = true
      name.classList.add("text-decoration-line-through")
    }
    this.#updateEmptyState()
  }

  #updateEmptyState() {
    const checkedItems = Array.from(this.checkedTarget.children)
      .filter(el => el !== this.emptyStateTarget)
    this.emptyStateTarget.style.display = checkedItems.length === 0 ? "block" : "none"

    const uncheckedItems = Array.from(this.uncheckedTarget.children)
      .filter(el => el !== this.allCheckedStateTarget)
    this.allCheckedStateTarget.style.display = uncheckedItems.length === 0 ? "block" : "none"
  }
}
