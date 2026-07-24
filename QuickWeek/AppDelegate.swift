import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover: NSPopover!
    var timer: Timer?

    private let fallbackRefreshInterval: TimeInterval = 3600
    private let popoverSize = NSSize(width: 280, height: 320)

    func applicationDidFinishLaunching(_ notification: Notification) {
        hideFromDock()

        popover = makeCalendarPopover()
        statusItem = makeStatusItem()
        updateCalendarWeek()

        timer = makeFallbackRefreshTimer()
        observeDateChanges()
    }

    func updateCalendarWeek() {
        statusItem.button?.title = WeekCalculator.menuBarTitle(for: Date())
    }

    @objc func handleDateChange() {
        updateCalendarWeek()
        popover.contentViewController = makeCalendarViewController()
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        guard let event = NSApp.currentEvent else { return }

        if event.type == .rightMouseUp {
            showContextMenu()
        } else {
            togglePopoverVisibility(sender)
        }
    }

    @objc func quit() {
        NSApplication.shared.terminate(nil)
    }

    private func hideFromDock() {
        NSApp.setActivationPolicy(.accessory)
    }

    private func makeStatusItem() -> NSStatusItem {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.action = #selector(togglePopover)
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        return statusItem
    }

    private func makeFallbackRefreshTimer() -> Timer {
        Timer.scheduledTimer(withTimeInterval: fallbackRefreshInterval, repeats: true) { [weak self] _ in
            self?.updateCalendarWeek()
        }
    }

    private func observeDateChanges() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDateChange),
            name: .NSCalendarDayChanged,
            object: nil
        )

        NSWorkspace.shared.notificationCenter.addObserver(
            self,
            selector: #selector(handleDateChange),
            name: NSWorkspace.didWakeNotification,
            object: nil
        )
    }

    private func makeCalendarPopover() -> NSPopover {
        let popover = NSPopover()
        popover.contentSize = popoverSize
        popover.behavior = .transient
        popover.contentViewController = makeCalendarViewController()
        return popover
    }

    private func makeCalendarViewController() -> NSViewController {
        NSHostingController(rootView: CalendarView())
    }

    private func showContextMenu() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "QuickWeek", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q"))
        statusItem.menu = menu
        statusItem.button?.performClick(nil)
        statusItem.menu = nil
    }

    private func togglePopoverVisibility(_ sender: AnyObject?) {
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
