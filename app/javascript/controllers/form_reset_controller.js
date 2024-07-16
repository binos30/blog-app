import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="form-reset"
export default class extends Controller {
  initialize() {
    const self = this;
    document.addEventListener("turbo:submit-end", function (event) {
      if (event.detail.success) self.element.reset();
    });
  }
}
