import { Controller } from "@hotwired/stimulus";
import { debouncePromise } from "../utils/debouncePromise";

// Connects to data-controller="posts"
export default class extends Controller {
  initialize() {
    this.search = debouncePromise(this.search.bind(this));
  }

  search(event) {
    const value = event.target.value.trim();
    const pathname = window.location.pathname;
    const url =
      pathname === "/users/posts" ? `/users/posts?search=${value}` : `/posts?search=${value}`;

    fetch(url, {
      method: "GET",
      mode: "cors",
      credentials: "same-origin",
      headers: {
        Accept: "text/vnd.turbo-stream.html"
      }
    })
      .then((response) => response.text())
      .then((html) => Turbo.renderStreamMessage(html));
  }
}
