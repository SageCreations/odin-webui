package tester

import ui "../"
import "core:fmt"
import "core:strings"

test_download_and_install :: proc() {
// ### Download and Install
example :: `
    # Add odin-webui as a submodule to your project
    git submodule add https://github.com/webui-dev/odin-webui.git webui

    # Linux/MacOS
    webui/setup.sh

    # Windows
    webui/setup.ps1
`
    fmt.printf("### Download And Install:")
    fmt.printfln(strings.concatenate({example, "\n\n"}))
}


test_minimal_example :: proc() {
// ### Minimal Example
example :: `
    // main.odin
    package main

    import ui "webui"

    main :: proc() {
        my_window: uint = ui.new_window()
        ui.show(my_window, "<html> <script src=\"webui.js\"></script> Thanks for using WebUI! </html>")
        ui.wait()
    }
`
    fmt.printf("### Minimal Example:")
    fmt.printfln(strings.concatenate({example, "\n\n"}))
}


test_new_window :: proc() {
// ### new_window
example :: `
package main

import ui "webui"

main :: proc() {
    my_window: uint = ui.new_window()

    // Later
    ui.show(my_window, "index.html")
}
`
    myWindow: uint = ui.new_window()
    output := fmt.aprintf("\nwindow number returned: %d", myWindow)

    fmt.printf("### new_window:")
    fmt.printfln(strings.concatenate({example, output, "\n\n"}))
    ui.destroy(myWindow)
}


test_new_window_id :: proc() {
// ### new_window_id
example :: `
package main

import ui "webui"

main :: proc() {
    /*
    * @param window_number The window number (should be > 0, and < 255)
    */

    win: uint = 1
    ui.new_window_id(win)

    // Later
    ui.show(win, "index.html")
}
`
    myWindow: uint = ui.new_window_id(123)
    output := fmt.aprintf("\nwindow number returned: %d", myWindow)

    fmt.printf("### new_window_id:")
    fmt.printfln(strings.concatenate({example, output, "\n\n"}))
    ui.destroy(myWindow)
}


test_get_new_window_id :: proc() {
// ### get_new_window_id
example :: `
package main

import ui "webui"

main :: proc() {

    win: uint = ui.get_new_window_id()

    // Later
    ui.new_window_id(win)
    ui.show(win, "index.html")
}
`
    win: uint = ui.get_new_window_id()
    output := fmt.aprintf("\nwindow number returned: %d", win)

    fmt.printf("### get_new_window_id:")
    fmt.printfln(strings.concatenate({example, output, "\n\n"}))
    ui.destroy(win)
}


test_bind :: proc() {
// ### bind
example :: `
package main

import ui "webui"

events :: proc "c" (e: ^ui.Event) {
    context = runtime.default_context()
    //
}

callback :: proc "c" (e: ^ui.Event) {
    context = runtime.default_context()
    //
}

main :: proc() {

    /*
    * @param window The window number
    * @param element The HTML element / JavaScript object
    * @param func The callback function
    */

    ui.bind(win, "", events)
    ui.bind(win, "callback", callback)
}
`
    // TODO:
}


test_event :: proc() {
// ### event
example :: `
package main

import ui "webui"

/*
    Event :: struct {
    	window: c.size_t,
    	event_type: EventType,
    	element: cstring,
    	event_number: c.size_t,
    	bind_id: c.size_t,
    	client_id: c.size_t,
    	connection_id: c.size_t,
    	cookies: cstring,
    }

    EventType :: enum {
    	Disconnected, 		// 0. Window disconnection event
    	Connected,        	// 1. Window connection event
    	MouseClick,      	// 2. Mouse click event
    	Navigation,       	// 3. Window navigation event
    	Callback,         	// 4. Function call event
    }
*/

events :: proc "c" (e: ^ui.Event) {
	context = runtime.default_context()

	switch e.event_type {
		case .Connected:
			fmt.println("Connected.")
		case .Disconnected:
			fmt.println("Disconnected.")
		case .MouseClick:
			fmt.println("Click.")
		case .Navigation:
			target, _ := ui.get_arg(string, e)
			fmt.println("Starting navigation to:", target)
		case .Callback:
			fmt.println("Callback")
	}
}

main :: proc() {

    /*
    * @param window The window number
    * @param element The HTML ID
    * @param func The callback function
    */

    ui.bind(win, "", events)
}
`
    // TODO:
}


test_get_best_browser :: proc() {
// ### get_best_browser
example :: `
package main

import ui "webui"

main :: proc() {

    /*
        Browser :: enum {
        	NoBrowser,  	// 0. No web browser
        	AnyBrowser, 	// 1. Default recommended web browser
        	Chrome,         // 2. Google Chrome
        	Firefox,        // 3. Mozilla Firefox
        	Edge,           // 4. Microsoft Edge
        	Safari,         // 5. Apple Safari
        	Chromium,       // 6. The Chromium Project
        	Opera,          // 7. Opera Browser
        	Brave,          // 8. The Brave Browser
        	Vivaldi,        // 9. The Vivaldi Browser
        	Epic,           // 10. The Epic Browser
        	Yandex,         // 11. The Yandex Browser
        	ChromiumBased,  // 12. Any Chromium based browser
        	Webview,        // 13. WebView (Non-web-browser)
        }
    */

    /*
    * @param window The window number
    */

    browserID: c.size_t = ui.get_best_browser(myWindow)
}
`
    // TODO:
}


test_show :: proc() {
// ### show
example :: `
package main

import ui "webui"

main :: proc() {

    /*
    * @param window The window number
    * @param content The HTML, URL, Or a local file
    */

    ui.show(myWindow, "<html><script src=\"/webui.js\"> ... </html>")
    ui.show(myWindow, "file.html")
    ui.show(myWindow, "https://mydomain.com")
}
`
    // TODO:
}


test_show_browser :: proc() {
// ### show_browser
example :: `
package main

import ui "webui"

main :: proc() {

    /*
        Browser :: enum {
        	NoBrowser,  	// 0. No web browser
        	AnyBrowser, 	// 1. Default recommended web browser
        	Chrome,         // 2. Google Chrome
        	Firefox,        // 3. Mozilla Firefox
        	Edge,           // 4. Microsoft Edge
        	Safari,         // 5. Apple Safari
        	Chromium,       // 6. The Chromium Project
        	Opera,          // 7. Opera Browser
        	Brave,          // 8. The Brave Browser
        	Vivaldi,        // 9. The Vivaldi Browser
        	Epic,           // 10. The Epic Browser
        	Yandex,         // 11. The Yandex Browser
        	ChromiumBased,  // 12. Any Chromium based browser
        	Webview,        // 13. WebView (Non-web-browser)
        }
    */

    /*
    * @param window The window number
    * @param content The HTML, Or a local file
    * @param browser The web browser to be used
    */

    ui.show_browser(myWindow, <html><script src=\"/webui.js\"> ... </html>", .Chrome)
}
`
    // TODO:
}


test_show_wv :: proc() {
// ### show_wv
example :: `
package main

import ui "webui"

main :: proc() {

    /*
    * @param window The window number
    * @param content The HTML, URL, Or a local file
    */

    ui.show_wv(myWindow, "index.html")
}
`
    // TODO:
}


test_set_kiosk :: proc() {
// ### set_kiosk
example :: `
package main

import ui "webui"

main :: proc() {

    /*
    * @param window The window number
    * @param status True or False
    */

    ui.set_kiosk(myWindow, true)
}
`
    // TODO:
}


test_wait :: proc() {
// ### wait
example :: `
package main

import ui "webui"

main :: proc() {

    ui.wait()
}
`
    // TODO:
}


test_close :: proc() {
// ### close
example :: `
package main

import ui "webui"

main :: proc() {

}
`
    // TODO:
}


test_destroy :: proc() {
// ### destroy
example :: `
package main

import ui "webui"

main :: proc() {

}
`
// TODO:
}


test_exit :: proc() {
// ### exit
example :: `
package main

import ui "webui"

main :: proc() {

}
`
    // TODO:
}


test_set_root_folder :: proc() {
// ### set_root_folder
example :: `
package main

import ui "webui"

main :: proc() {

}
`
    // TODO:
}


test_set_default_root_folder :: proc() {
// ### set_default_root_folder
example :: `
package main

import ui "webui"

main :: proc() {

}
`
    // TODO:
}


test_set_file_handler :: proc () {
// ### set_file_handler
example :: `
package main

import ui "webui"

main :: proc() {

}
`
// TODO:
}


test_is_shown :: proc() {
// ### is_shown
example :: `
package main

import ui "webui"

main :: proc() {

}
`
// TODO:
}


test_set_timeout :: proc() {
// ### set_timeout
example :: `
package main

import ui "webui"

main :: proc() {

}
`
// TODO:
}


test_set_icon :: proc() {
// ### set_icon
example :: `
package main

import ui "webui"

main :: proc() {

}
`
// TODO:
}


test_encode :: proc() {
// ### encode
example :: `
package main

import ui "webui"

main :: proc() {

}
`
// TODO:
}


test_decode :: proc() {
// ### decode
example :: `
package main

import ui "webui"

main :: proc() {

}
`
// TODO:
}


test_free :: proc() {
// ### free
example :: `
package main

import ui "webui"

main :: proc() {

}
`
// TODO:
}


test_malloc :: proc() {
// ### malloc
example :: `
package main

import ui "webui"

main :: proc() {

}
`
// TODO:
}


test_send_raw :: proc() {
// ### send_raw
example :: `
package main

import ui "webui"

main :: proc() {

}
`
// TODO:
}


test_set_hide :: proc() {
// ### set_hide
example :: `
package main

import ui "webui"

main :: proc() {

}
`
// TODO:
}


test_set_size :: proc() {
// ### set_size
example :: `
package main

import ui "webui"

main :: proc() {

}
`
// TODO:
}


test_set_position :: proc() {
// ### set_position
example :: `
package main

import ui "webui"

main :: proc() {

}
`
// TODO:
}


test_set_profile :: proc() {
// ### set_profile
example :: `
package main

import ui "webui"

main :: proc() {

}
`
// TODO:
}


test_set_proxy :: proc() {
// ### set_proxy
example :: `
package main

import ui "webui"

main :: proc() {

}
`
// TODO:
}


test_get_url :: proc() {
// ### get_url
example :: `
package main

import ui "webui"

main :: proc() {

}
`
// TODO:
}


test_set_public :: proc() {
// ### set_public
example :: `
package main

import ui "webui"

main :: proc() {

}
`
// TODO:
}


test_navigate :: proc() {
// ### navigate
example :: `
package main

import ui "webui"

main :: proc() {

}
`
// TODO:
}


test_clean :: proc() {
// ### clean
example :: `
package main

import ui "webui"

main :: proc() {

}
`
// TODO:
}


test_delete_all_profiles :: proc() {
// ### delete_all_profiles
example :: `
package main

import ui "webui"

main :: proc() {

}
`
// TODO:
}


test_delete_profile :: proc() {
// ### delete_profile
example :: `
package main

import ui "webui"

main :: proc() {

}
`
// TODO:
}


test_get_parent_process_id :: proc() {
// ### get_parent_process_id
example :: `
package main

import ui "webui"

main :: proc() {

}
`
// TODO:
}


test_get_child_process_id :: proc() {
// ### get_child_process_id
example :: `
package main

import ui "webui"

main :: proc() {

}
`
// TODO:
}


test_set_port :: proc() {
// ### set_port
example :: `
package main

import ui "webui"

main :: proc() {

}
`
// TODO:
}

// ### set_config
// ### set_event_blocking
// ### set_tls_certificate
// ### run
// ### script
// ### set_runtime
// ### get_count
// ### get_int_at
// ### get_int
// ### get_float_at
// ### get_float
// ### get_string_at
// ### get_string
// ### get_bool_at
// ### get_bool
// ### get_size_at
// ### get_size
// ### return_int
// ### return_float
// ### return_string
// ### return_bool
// ### open_url
// ### start_server
// ### get_mime_type
// ### get_port
// ### get_free_port
// ### JavaScript - call
// ### JavaScript - isConnected
// ### JavaScript - setEventCallback
// ### JavaScript - encode
// ### JavaScript - decode
// ### JavaScript - isHighContrast
// ### JavaScript - setLogging


main :: proc() {

    when true {
        test_download_and_install()
        test_minimal_example()
        test_new_window()
        test_new_window_id()
        test_get_new_window_id()
        test_bind()
        test_event()
        test_get_best_browser()
        test_show()
        test_show_browser()
        test_show_wv()
        test_set_kiosk()
        test_wait()
        test_close()
        test_destroy()
        test_exit()
        test_set_root_folder()
        test_set_default_root_folder()
        test_set_file_handler()
        test_is_shown()
        test_set_timeout()
        test_set_icon()
        test_encode()
        test_decode()
        test_free()
        test_malloc()
        test_send_raw()
        test_set_hide()
        test_set_size()
        test_set_position()
        test_set_profile()
        test_set_proxy()
        test_get_url()
        test_set_public()
        test_navigate()
        test_clean()
        test_delete_all_profiles()
        test_delete_profile()
        test_get_parent_process_id()
        test_get_child_process_id()
        test_set_port()
//        test_set_config()
//        test_set_event_blocking()
//        test_set_tls_certificate()
//        test_run()
//        test_script()
//        test_set_runtime()
//        test_get_count()
//        test_get_int_at()
//        test_get_int()
//        test_get_float_at()
//        test_get_float()
//        test_get_string_at()
//        test_get_string()
//        test_get_bool_at()
//        test_get_bool()
//        test_get_size_at()
//        test_get_size()
//        test_return_int()
//        test_return_float()
//        test_return_string()
//        test_return_bool()
//        test_open_url()
//        test_start_server()
//        test_get_mime_type()
//        test_get_port()
//        test_get_free_port()
    }

}