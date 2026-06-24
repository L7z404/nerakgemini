// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//
// If you have dependencies that try to import CSS, esbuild will generate a separate `app.css` file.
// To load it, simply add a second `<link>` to your `root.html.heex` file.

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import {hooks as colocatedHooks} from "phoenix-colocated/nerakgemini"
import topbar from "../vendor/topbar"

/* A WYSIWYG editor plugin. You can update this file by fetching the latest version with:
   https://www.jsdelivr.com/package/npm/trix
   curl -sLo trix.js https://cdn.jsdelivr.net/npm/trix@X.X.X/dist/trix.umd.min.js */
import "../vendor/trix";

// Backpex Admin
import {Hooks as BackpexHooks} from 'backpex';

// const Hooks = [] // My app hooks (optional)
const Hooks = {
  Trix: {
    mounted() {
      const textarea = this.el.querySelector("textarea");
      textarea.hidden = true;
      textarea.id = textarea.id || `trix-textarea-${Date.now()}`;

      const editor = document.createElement("trix-editor");
      editor.setAttribute("input", textarea.id);
      this.el.appendChild(editor);

      this.el.addEventListener("trix-change", () => {
        textarea.value = editor.innerHTML;
        textarea.dispatchEvent(new Event("input", {bubbles: true} ))
      });

      this.el.addEventListener("trix-attachment-add", (event) => {
          const { attachment } = event;
          if (!attachment.file) return; // skip SGIDs / non-file attachments

          const formData = new FormData();
          formData.append("file", attachment.file);

          const csrf = document
            .querySelector("meta[name='csrf-token']")
            .getAttribute("content");

          fetch("/admin/uploads/images", {
            method: "POST",
            headers: { "x-csrf-token": csrf },
            body: formData,
          })
          .then((r) => r.json())
          .then(({ url }) => {
            attachment.setAttributes({ url, href: url });
          })
          .catch(() => {
            attachment.remove();
          });

      });
      
    }
  }
};

const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: {...colocatedHooks, ...Hooks, ...BackpexHooks},
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

// The lines below enable quality of life phoenix_live_reload
// development features:
//
//     1. stream server logs to the browser console
//     2. click on elements to jump to their definitions in your code editor
//
if (process.env.NODE_ENV === "development") {
  window.addEventListener("phx:live_reload:attached", ({detail: reloader}) => {
    // Enable server log streaming to client.
    // Disable with reloader.disableServerLogs()
    reloader.enableServerLogs()

    // Open configured PLUG_EDITOR at file:line of the clicked element's HEEx component
    //
    //   * click with "c" key pressed to open at caller location
    //   * click with "d" key pressed to open at function component definition location
    let keyDown
    window.addEventListener("keydown", e => keyDown = e.key)
    window.addEventListener("keyup", e => keyDown = null)
    window.addEventListener("click", e => {
      if(keyDown === "c"){
        e.preventDefault()
        e.stopImmediatePropagation()
        reloader.openEditorAtCaller(e.target)
      } else if(keyDown === "d"){
        e.preventDefault()
        e.stopImmediatePropagation()
        reloader.openEditorAtDef(e.target)
      }
    }, true)

    window.liveReloader = reloader
  })
}


