import AppKit

let app = NSApplication.shared
let appDelegate = WakeAppDelegate()

app.setActivationPolicy(.accessory)
app.delegate = appDelegate
app.run()
