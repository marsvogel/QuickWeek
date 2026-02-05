import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var timer: Timer?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide from dock
        NSApp.setActivationPolicy(.accessory)

        // Create status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        updateCalendarWeek()

        // Update every hour (calendar week doesn't change often)
        timer = Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { [weak self] _ in
            self?.updateCalendarWeek()
        }

        // Create menu
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quick Week", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Beenden", action: #selector(quit), keyEquivalent: "q"))
        statusItem.menu = menu
    }

    func updateCalendarWeek() {
        let calendar = Calendar(identifier: .iso8601)
        let weekNumber = calendar.component(.weekOfYear, from: Date())

        if let button = statusItem.button {
            button.title = "KW \(weekNumber)"
        }
    }

    @objc func quit() {
        NSApplication.shared.terminate(nil)
    }
}
