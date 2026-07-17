import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover: NSPopover!
    var timer: Timer?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide from dock
        NSApp.setActivationPolicy(.accessory)

        // Create status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        updateCalendarWeek()

        // Update every hour as fallback
        timer = Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { [weak self] _ in
            self?.updateCalendarWeek()
        }

        // Update immediately when the date changes (midnight)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDateChange),
            name: .NSCalendarDayChanged,
            object: nil
        )

        // Update when waking from sleep
        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(handleDateChange),
            name: NSWorkspace.didWakeNotification,
            object: nil
        )

        // Create popover with calendar view
        popover = NSPopover()
        popover.contentSize = NSSize(width: 280, height: 320)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: CalendarView())

        // Set up button action for left click
        if let button = statusItem.button {
            button.action = #selector(togglePopover)
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
    }

    func updateCalendarWeek() {
        statusItem.button?.title = WeekCalculator.menuBarTitle(for: Date())
    }

    @objc func handleDateChange() {
        updateCalendarWeek()
        // Recreate popover content so CalendarView picks up the new date
        popover.contentViewController = NSHostingController(rootView: CalendarView())
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        guard let event = NSApp.currentEvent else { return }

        if event.type == .rightMouseUp {
            // Right click - show context menu
            let menu = NSMenu()
            menu.addItem(NSMenuItem(title: "QuickWeek", action: nil, keyEquivalent: ""))
            menu.addItem(NSMenuItem.separator())
            menu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q"))
            statusItem.menu = menu
            statusItem.button?.performClick(nil)
            statusItem.menu = nil
        } else {
            // Left click - toggle popover
            if popover.isShown {
                popover.performClose(sender)
            } else {
                if let button = statusItem.button {
                    popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                    popover.contentViewController?.view.window?.makeKey()
                }
            }
        }
    }

    @objc func quit() {
        NSApplication.shared.terminate(nil)
    }
}
