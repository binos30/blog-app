import { Controller } from "@hotwired/stimulus";
import TurboProgressBar from "../components/TurboProgressBar";
import { debouncePromise } from "../utils/debouncePromise";

// Connects to data-controller="posts"
export default class extends Controller {
  initialize() {
    this.submitFilter = debouncePromise(this.submitFilter.bind(this));
    this.turboProgressBar = new TurboProgressBar();
  }

  search(event) {
    this.turboProgressBar.show();
    const value = event.target.value.trim();
    const pathname = window.location.pathname;
    const url = pathname === "/users/posts" ? `/users/posts?search=${value}` : `/posts?search=${value}`;

    fetch(url, {
      method: "GET",
      mode: "cors",
      credentials: "same-origin",
      headers: {
        Accept: "text/vnd.turbo-stream.html"
      }
    })
      .then((response) => response.text())
      .then((html) => {
        this.turboProgressBar.hide();
        Turbo.renderStreamMessage(html);
      });
  }

  submitFilter() {
    this.element.requestSubmit();
  }
}
