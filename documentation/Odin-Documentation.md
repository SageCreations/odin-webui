# Odin-Webui Documentation



// ** functions currently not in the website's documentation:
// show_client
// set_file_handler_window
// set_minimum_size


### Download and Install
```sh
# Add odin-webui as a submodule to your project
git submodule add https://github.com/webui-dev/odin-webui.git webui

# Linux/MacOS
webui/setup.sh

# Windows
webui/setup.ps1
```


### Minimal Example
```odin
// main.odin
package main

import ui "webui"

main :: proc() {
    my_window: uint = ui.new_window()
    ui.show(my_window, "<html> <script src=\"webui.js\"></script> Thanks for using WebUI! </html>")
    ui.wait()
}
```


### new_window
```odin
package main

import ui "webui"

main :: proc() {
    my_window: uint = ui.new_window()

    // Later
    ui.show(my_window, "index.html")
}
```


### new_window_id
```odin
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
```


### get_new_window_id
```odin
package main

import ui "webui"

main :: proc() {

    win: uint = ui.get_new_window_id()

    // Later
    ui.new_window_id(win)
    ui.show(win, "index.html")
}
```


### bind
```odin
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
```


### event
```odin
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
```


### get_best_browser
```odin
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

    browserID: uint = ui.get_best_browser(my_window)
}
```


### show
```odin
package main

import ui "webui"

main :: proc() {

    /*
    * @param window The window number
    * @param content The HTML, URL, Or a local file
    */

    ui.show(my_window, "<html><script src=\"/webui.js\"></script> ... </html>")
    ui.show(my_window, "file.html")
    ui.show(my_window, "https://mydomain.com")
}
```


// TODO: show_client


### show_browser
```odin
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

    ui.show_browser(my_window, "<html><script src=\"/webui.js\"></script> ... </html>", .Chrome)
}
```


### show_wv
```odin
package main

import ui "webui"

main :: proc() {

    /*
    * @param window The window number
    * @param content The HTML, URL, Or a local file
    */

    ui.show_wv(my_window, "index.html")
}
```


### set_kiosk
```odin
package main

import ui "webui"

main :: proc() {

    /*
    * @param window The window number
    * @param status True or False
    */

    ui.set_kiosk(my_window, true)
}
```


### wait
```odin
package main

import ui "webui"

main :: proc() {

    ui.wait()
}
```


### close
```odin
package main

import ui "webui"

callback :: proc "c" (e: ^ui.Event) {
    context = runtime.default_context()

    /*
    * @param e The event struct
    */

    ui.close_client(e)
}

main :: proc() {
    /*
    * @param window The window number
    */

    ui.close(win)
}
```


### destroy
```odin
package main

import ui "webui"

main :: proc() {
    /*
    * @param window The window number
    */

    ui.destroy(win)
}
```


### exit
```odin
package main

import ui "webui"

main :: proc() {

    ui.exit()
}
```


### set_root_folder
```odin
package main

import ui "webui"

main :: proc() {

    /*
    * @param window The window number
    * @param path The local folder full path
    */

    ui.set_root_folder(my_window, "/home/Foo/Bar/")
}
```


### set_default_root_folder
```odin
package main

import ui "webui"

main :: proc() {

    /*
    * @param path The local folder full path
    */

    ui.set_default_root_folder("/home/Foo/Bar/")
}
```


### set_file_handler
```odin
package main

import ui "webui"

filesHandler :: proc "c" (filename: cstring, length: i32) -> rawptr {
    context = runtime.default_context()

    // code
    return rawptr
}

main :: proc() {

    /*
    * @param window The window number
    * @param handler The handler function
    */

    ui.set_file_handler(my_window, filesHandler)
}
```


// TODO: set_file_handler_window


### is_shown
```odin
package main

import ui "webui"

main :: proc() {

    /*
    * @param window The window number
    */

    if ui.is_shown(my_window) {
        // Window is shown
    } else {
        // Window is closed
    }
}
```


### set_timeout
```odin
package main

import ui "webui"

main :: proc() {

    /*
    * @param second The timeout in seconds
    */

    ui.set_timeout(30)

    ui.show(win, "index.html")
    ui.wait()
}
```


### set_icon
```odin
package main

import ui "webui"

main :: proc() {

    /*
    * @param window The window number
    * @param icon The icon as string: '<svg>...</svg>'
    * @param icon_type The icon type: 'image/svg+xml'
    */

    ui.set_icon(win, "<svg>...</svg>", "image/svg+xml")
}
```


### encode
```odin
package main

import ui "webui"

main :: proc() {

    /*
    * @param str The string to encode
    */

    base64: cstring = ui.encode("Foo Bar")

    // Later
    ui.free(base64)
}
```


### decode
```odin
package main

import ui "webui"

callback :: proc "c" (e: ^ui.Event) {
    context = runtime.default_context()

    // JavaScript:
    // callback(Base64)
    base64: cstring = ui.get_string(e)

    /*
    * @param str The string to decode
    */

    str: cstring = ui.decode(base64)

    // Later
    ui.free(str)
}
```


### free
```odin
package main

import ui "webui"

main :: proc() {
    myBuffer := cast(^u8)ui.malloc(1024)

    /*
    * @param ptr The buffer to be freed
    */

    ui.free(myBuffer)
}
```


### malloc
```odin
package main

import ui "webui"

main :: proc() {

    /*
    * @param size The size of memory in bytes
    */

    myBuffer := cast(^u8)ui.malloc(1024)

    // Later
    ui.free(myBuffer)
}
```


### send_raw
```odin
package main

import ui "webui"

callback :: proc "c" (e: ^ui.Event) {
    context = runtime.default_context()

    ui.send_raw_client(e, "myJavaScriptFunc", raw_data(buffer), 3)
}

main :: proc() {

    /*
    * @param window The window number
    * @param function The JavaScript function to receive raw data
    * @param raw The raw data buffer
    * @param size The raw data size in bytes
    */

    buffer: []byte = { 0x01, 0x02, 0x03 } // Any data type
    ui.send_raw(my_window, "myJavaScriptFunc", raw_data(buffer), len(buffer))

    // JavaScript:
    //
    // function myJavaScriptFunc(rawData) {
    //    'rawData' is Uint8Array type
    // }
}
```


### set_hide
```odin
package main

import ui "webui"

main :: proc() {

    /*
    * @param window The window number
    * @param status The status: True or False
    */

    ui.set_hide(my_window, true)
}
```


### set_size
```odin
package main

import ui "webui"

main :: proc() {

    /*
    * @param window The window number
    * @param width The window width
    * @param height The window height
    */

    ui.set_size(my_window, 800, 600)
}
```


### set_position
```odin
package main

import ui "webui"

main :: proc() {

    /*
    * @param window The window number
    * @param x The window X
    * @param y The window Y
    */

    ui.set_position(my_window, 100, 100)
}
```


TODO: set_minimum_size


### set_profile
```odin
package main

import ui "webui"

main :: proc() {

    /*
    * @param window The window number
    * @param name The web browser profile name
    * @param path The web browser profile full path
    */

    ui.set_profile(my_window, "Bar", "/Home/Foo/Bar")
}
```


### set_proxy
```odin
package main

import ui "webui"

main :: proc() {

    /*
    * @param window The window number
    * @param proxy_server The web browser proxy_server
    */

    ui.set_proxy(my_window, "http://127.0.0.1:8888")
}
```


### get_url
```odin
package main

import ui "webui"

main :: proc() {

    /*
    * @param window The window number
    */

    url: cstring = ui.get_url(my_window)
}
```


### set_public
```odin
package main

import ui "webui"

main :: proc() {

    /*
    * @param window The window number
    * @param status True or False
    */

    ui.set_public(my_window, true)

    // Now, the URL of the window is accessible
    // from any device/mobile in the network.
}
```


### navigate
```odin
package main

import ui "webui"

main :: proc() {

    /*
    * @param window The window number
    * @param url Full HTTP URL
    */

    ui.navigate(win, "/foo/bar.html")

    // [!] Note:
    //
    // If 'bar.html' does not include 'webui.js' then
    // WebUI will try to close the window and 'wait()'
    // will break. It's important to include 'webui.js'
    // in every HTML.
}
```


### clean
```odin
package main

import ui "webui"

main :: proc() {

    ui.clean()
}
```


### delete_all_profiles
```odin
package main

import ui "webui"

main :: proc() {

	ui.delete_all_profiles()
}
```


### delete_profile
```odin
package main

import ui "webui"

main :: proc() {

    /*
    * @param window The window number
    */

    ui.delete_profile(my_window)
}
```


### get_parent_process_id
```odin
package main

import ui "webui"

main :: proc() {

    /*
    * @param window The window number
    */

    parent_pid: uint = ui.get_parent_process_id(my_window)
}
```


### get_child_process_id
```odin
package main

import ui "webui"

main :: proc() {

    /*
    * @param window The window number
    */

    child_pid: uint = ui.get_child_process_id(my_window)
}
```


### set_port
```odin
package main

import ui "webui"

main :: proc() {

    /*
    * @param window The window number
    * @param port The web-server network port WebUI should use
    */

    ret: bool = ui.set_port(my_window, 8080)

    if !ret {
        fmt.printfln("The port is busy and not usable.")
    }

    // The port '8080' will not be used by WebUI
    // until we show the window. The window URL
    // then will be: http://localhost:8080/
}
```


### set_config
```odin
package main

import ui "webui"

main :: proc() {

    /*
        Config :: enum {
        // Control if 'webui_show()', 'webui_show_browser()' and
        // 'webui_show_wv()' should wait for the window to connect
        // before returns or not.
        //
        // Default: True
        show_wait_connection,
        // Control if WebUI should block and process the UI events
        // one a time in a single thread 'True', or process every
        // event in a new non-blocking thread 'False'. This updates
        // all windows. You can use 'webui_set_event_blocking()' for
        // a specific single window update.
        //
        // Default: False
        ui_event_blocking,
        // Automatically refresh the window UI when any file in the
        // root folder gets changed.
        //
        // Default: False
        folder_monitor,
        // Allow multiple clients to connect to the same window,
        // This is helpful for web apps (non-desktop software),
        // Please see the documentation for more details.
        //
        // Default: False
        multi_client,
        // Allow or prevent WebUI from adding 'webui_auth' cookies.
        // WebUI uses these cookies to identify clients and block
        // unauthorized access to the window content using a URL.
        // Please keep this option to 'True' if you want only a single
        // client to access the window content.
        //
        // Default: True
        use_cookies,
        // If the backend uses asynchronous operations, set this
        // option to 'True'. This will make webui wait until the
        // backend sets a response using 'webui_return_x()'.
        asynchronous_response
    */

    /*
    * @param option The desired option from 'webui_config' enum
    * @param status The status of the option, 'true' or 'false'
    */

    ui.set_config(.show_wait_connection, true)
    ui.set_config(.ui_event_blocking, false)
    ui.set_config(.folder_monitor, true)
}
```


### set_event_blocking
```odin
package main

import ui "webui"

foo :: proc "c" (e: ^ui.Event) {
    context = runtime.default_context()
    //
}

bar :: proc "c" (e: ^ui.Event) {
    context = runtime.default_context()
    //
}

main :: proc() {

    ui.bind(my_window, "foo", foo)
    ui.bind(my_window, "bar", bar)

    /*
    * @param window The window number
    * @param status The blocking status 'true' or 'false'
    */

    ui.set_event_blocking(my_window, true)

    // Now, every UI event will be processed
    // in one single thread, other UI events
    // will be blocked until first event end

    // JavaScript:
    // foo();
    // bar();
}
```


### set_tls_certificate
```odin
package main

import ui "webui"

main :: proc() {

    /*
    * @param certificate_pem The SSL/TLS certificate content in PEM format
    * @param private_key_pem The private key content in PEM format
    */

    ret: bool = ui.set_tls_certificate(
        "-----BEGIN CERTIFICATE-----\n...",
        "-----BEGIN PRIVATE KEY-----\n..."
    )

    if !ret {
        fmt.printfln("Invalid TLS certificate.")
    }
}
```


### run
```odin
package main

import ui "webui"

callback :: proc "c" (e: ^ui.Event) {

    /*
    * @param e The event struct
    * @param script The JavaScript to be run
    */

    // Run javascript for one specific client

    ui.run_client(e, "alert('Foo Bar');")
}

main :: proc() {

    /*
    * @param window The window number
    * @param script The JavaScript to be run
    */

    // Run javascript for all connected clients in a window

    ui.run(my_window, "alert('Foo Bar');")
}
```


### script
```odin
package main

import ui "webui"

callback :: proc "c" (e: ^ui.Event) {
    context = runtime.default_context()

    /*
    * @param e The event struct
    * @param script The JavaScript to be run
    * @param timeout The execution timeout
    * @param buffer The local buffer to hold the response
    * @param buffer_length The local buffer size
    */

    // Run javascript for one specific client

    response: cstring = ""
    if !ui.script_client(e, "return 4 + 6;", 0, response, 64) {
        fmt.printfln("JavaScript Error: %s", response)
    }
    else {
        fmt.printfln("JavaScript Response: %s", response) // 10
    }
}

main :: proc() {

    /*
    * @param window The window number
    * @param script The JavaScript to be run
    * @param timeout The execution timeout
    * @param buffer The local buffer to hold the response
    * @param buffer_length The local buffer size
    */

    // Run javascript

    response: cstring = ""
    if !ui.webui_script(my_window, "return 4 + 6;", 0, response, 64) {
        fmt.printfln("JavaScript Error: %s", response)
    }
    else {
        fmt.printfln("JavaScript Response: %s", response) // 10
    }
}
```


### set_runtime
```odin
package main

import ui "webui"

main :: proc() {

    /*
    * @param window The window number
    * @param runtime None | Deno | Nodejs | Bun
    */

    ui.set_runtime(my_window, .Deno)

    // Now, any HTTP request to any '.js' or '.ts' file
    // will be interpreted by Deno.
    //
    // JavaScript:
    //
    // var xmlHttp = new XMLHttpRequest();
    // xmlHttp.open('GET', 'test.ts?foo=123&bar=456', false);
    // xmlHttp.send(null);
    //
    // console.log(xmlHttp.responseText);
}
```


### get_count
```odin
package main

import ui "webui"

callback :: proc "c" (e: ^ui.Event) {
    context = runtime.default_context()

    // JavaScript:
    // callback("Foo", "Bar", 123, true);

    count: uint = ui.get_count(e) // 4
}
```


### get_int_at
```odin
package main

import ui "webui"

callback :: proc "c" (e: ^ui.Event) {
    context = runtime.default_context()

    // JavaScript:
    // callback(12345, 6789);

    n1: i64 = ui.get_int_at(e, 0)
    n2: i64 = ui.get_int_at(e, 1)
}
```


### get_int
```odin
package main

import ui "webui"

callback :: proc "c" (e: ^ui.Event) {
    context = runtime.default_context()

    // JavaScript:
    // callback(123456);

    num: i64 = ui.get_int(e)
}
```


### get_float_at
```odin
package main

import ui "webui"

callback :: proc "c" (e: ^ui.Event) {
    context = runtime.default_context()

    // JavaScript:
    // callback(12.34, 56.789);

    f1: f64 = ui.get_float_at(e, 0)
    f2: f64 = ui.get_float_at(e, 1)
}
```


### get_float
```odin
package main

import ui "webui"

callback :: proc "c" (e: ^ui.Event) {
    context = runtime.default_context()

    // JavaScript:
    // callback(123.456);

    f: f64 = ui.get_float(e)
}
```


### get_string_at
```odin
package main

import ui "webui"

callback :: proc "c" (e: ^ui.Event) {
    context = runtime.default_context()

    // JavaScript:
    // callback("Foo", "Bar");

    foo: cstring = ui.get_string_at(e, 0)
    bar: cstring = ui.get_string_at(e, 1)
}
```


### get_string
```odin
package main

import ui "webui"

callback :: proc "c" (e: ^ui.Event) {
    context = runtime.default_context()

    // JavaScript:
    // callback("Foo Bar");

    name: cstring = ui.get_string(e)
}
```


### get_bool_at
```odin
package main

import ui "webui"

callback :: proc "c" (e: ^ui.Event) {
    context = runtime.default_context()

    // JavaScript:
    // callback(true, false);

    status1: bool = ui.get_bool_at(e, 0)
    status2: bool = ui.get_bool_at(e, 1)
}
```


### get_bool
```odin
package main

import ui "webui"

callback :: proc "c" (e: ^ui.Event) {
    context = runtime.default_context()

    // JavaScript:
    // callback(true);

    status: bool = ui.get_bool(e)
}
```


### get_size_at
```odin
package main

import ui "webui"

callback :: proc "c" (e: ^ui.Event) {
    context = runtime.default_context()

    // JavaScript:
    // callback("Foo", "Bar");

    fooLen: uint = ui.get_size_at(e, 0)
    barLen: uint = ui.get_size_at(e, 1)
}
```


### get_size
```odin
package main

import ui "webui"

callback :: proc "c" (e: ^ui.Event) {
    context = runtime.default_context()

    // JavaScript:
    // callback("Foo");

    fooLen: uint = ui.get_size(e)
}
```


### return_int
```odin
package main

import ui "webui"

callback :: proc "c" (e: ^ui.Event) {
    context = runtime.default_context()

    // JavaScript:
    // var num = await callback();

    // Return
    ui.return_int(e, 123456)
}
```


### return_float
```odin
package main

import ui "webui"

callback :: proc "c" (e: ^ui.Event) {
    context = runtime.default_context()

    // JavaScript:
    // var f = await callback();

    // Return
    ui.return_float(e, 123.456)
}
```


### return_string
```odin
package main

import ui "webui"

callback :: proc "c" (e: ^ui.Event) {
    context = runtime.default_context()

    // JavaScript:
    // var name = await callback();

    // Return
    ui.return_string(e, "Foo Bar")
}
```


### return_bool
```odin
package main

import ui "webui"

callback :: proc "c" (e: ^ui.Event) {
    context = runtime.default_context()

    // JavaScript:
    // var status = await callback();

    // Return
    ui.return_bool(e, true)
}
```


### open_url
```odin
package main

import ui "webui"

main :: proc() {

    /*
    * @param url The URL to open
    */

    ui.open_url("https://webui.me")
}
```


### start_server
```odin
package main

import ui "webui"

main :: proc() {

    /*
    * @param window The window number
	* @param content The HTML, Or a local file
    */

    url: cstring = ui.start_server(myWindow, "/full/root/path")
}
```


### get_mime_type
```odin
package main

import ui "webui"

main :: proc() {

    /*
    * @param file The path to and or, with the file included
    */

    mime: cstring = ui.get_mime_type("foo.png")
}
```


### get_port
```odin
package main

import ui "webui"

main :: proc() {

    /*
    * @param window The window number
    */

    port: uint = ui.get_port(my_window)
}
```


### get_free_port
```odin
package main

import ui "webui"

main :: proc() {

    port: uint = ui.get_free_port()
}
```
