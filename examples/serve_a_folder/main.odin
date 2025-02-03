// This examples needs to be executed relative to the examples directory.
// E.g.: `cd examples/serve_a_folder` then `odin run .` NOT `odin run examples/serve_a_folder`.
package serve_a_folder

import ui "../../"
import "base:runtime"
import "core:fmt"
import "core:strings"


my_window : uint : 1
my_second_window : uint : 2


exit_app :: proc "c" (e: ^ui.Event) {
	context = runtime.default_context()

	// Close all opened windows
	if e.window == my_second_window {
		fmt.printfln("ui.close was called")
		ui.close(e.window)
	} else {
		fmt.printfln("ui.exit was called")
		ui.exit()
	}
}

// // This function gets called every time there is an event.
events :: proc "c" (e: ^ui.Event) {
	context = runtime.default_context()

	#partial switch e.event_type {
	case .Connected:
		fmt.println("Connected.")
	case .Disconnected:
		fmt.println("Disconnected.")
	case .MouseClick:
		fmt.println("Click.")
	case .Navigation:
		target, _ := ui.get_arg(string, e)
		fmt.println("Starting navigation to:", target)

		// Because we used `bind(my_window, "", events)`
		// WebUI will block all `href` link clicks and sent here instead.
		// We can then control the behaviour of links as needed.
		ui.navigate(e.window, target)
	}
}

// Switch to `/second.html` in the same opened window.
switch_to_second_page :: proc "c" (e: ^ui.Event) {
	context = runtime.default_context()

	// This function gets called every
	// time the user clicks on "SwitchToSecondPage"

	// Switch to `/second.html` in the same opened window.
	ui.show(e.window, "second.html")
}

show_second_window :: proc "c" (e: ^ui.Event) {
	context = runtime.default_context()

	// This function gets called every
	// time the user clicks on "OpenNewWindow"

	// Show a new window, and navigate to `/second.html`
	// if it's already open, then switch in the same window
	ui.show(my_second_window, "second.html")
}

my_files_handler :: proc "c" (filename: cstring, length: ^i32) -> rawptr {
	context = runtime.default_context()

	fmt.printfln("File: %s ", string(filename))

	if strings.compare(string(filename), "/test.txt") == 0 {
		// Const static file example
		static_file_ex := fmt.aprint(
			"HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: 99\r\n\r\n<html>This is a static embedded file content example.<script src=\"webui.js\"></script></html>"
		)

		return rawptr(raw_data(transmute([]u8)static_file_ex))
	} else if strings.compare(string(filename), "/dynamic.html") == 0 {
		// Dynamic file example

		// Generate body
		@(static) count: i32 = 1
		body := fmt.aprintf(
			"<html>This is a dynamic file content example. <br>Count: %d <a href=\"dynamic.html\">[Refresh]</a><br><script src=\"webui.js\"></script></html>",
			count,
		)
		count += 1
		body_size: int = len(body)

		header_and_body := fmt.aprintf(
			"HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: %d\r\n\r\n%s",
			body_size, body,
		)

		return rawptr(raw_data(transmute([]u8)header_and_body))
	}

	// Other files:
	// A NULL return will make WebUI
	// looks for the file locally.
	return nil
}



main :: proc() {
	// Create new windows
	ui.new_window_id(my_window)
	ui.new_window_id(my_second_window)

	// Bind HTML element IDs with a C functions
	ui.bind(my_window, "SwitchToSecondPage", switch_to_second_page)
	ui.bind(my_window, "OpenNewWindow", show_second_window)
	ui.bind(my_window, "Exit", exit_app)
	ui.bind(my_second_window, "Exit", exit_app)

	// Bind events
	ui.bind(my_window, "", events)

	// Set the `.ts` and `.js` runtime
	// ui.set_runtime(my_window, .NodeJS)
	ui.set_runtime(my_window, .Bun)
	// ui.set_runtime(my_window, .Deno) // errors with deno 2.0+ with depricated commands being called in the C implementation.

	// Set a custom files handler
	ui.set_file_handler(my_window, my_files_handler)

	// Set window size
	ui.set_size(my_window, 800, 800)

	// Set window position
	ui.set_position(my_window, 200, 200)

	// Show a new window
	// ui.set_root_folder(my_window, "_MY_PATH_HERE_")
	 ui.show_browser(my_window, "index.html", .Firefox)
	//ui.show(my_window, "index.html")

	// Wait until all windows get closed
	ui.wait()

	// Free all memory resources (Optional)
	ui.clean()
}
