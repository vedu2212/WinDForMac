import Cocoa
import SwiftUI
import Carbon

@main
struct WinDForMacApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        Settings {
            Text("Win+D is running in the background.")
                .padding()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var isMinimizedState = false

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let promptOpts = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
        AXIsProcessTrustedWithOptions(promptOpts)

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "macwindow", accessibilityDescription: nil)        }
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = menu

        registerHotKey()
    }

    func registerHotKey() {
        var hotKeyRef: EventHotKeyRef?
        let hotKeyID = EventHotKeyID(signature: UInt32(1234), id: 1)
        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        
        let ptr = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())

        InstallEventHandler(GetApplicationEventTarget(), { (nextHandler, theEvent, userData) -> OSStatus in
            let mySelf = Unmanaged<AppDelegate>.fromOpaque(userData!).takeUnretainedValue()
            mySelf.toggleWindows()
            return noErr
        }, 1, &eventType, ptr, nil)

        // 2 is the keycode for 'D', 2048 is the Option key modifier
        RegisterEventHotKey(UInt32(2), UInt32(2048), hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef)
    }

    func toggleWindows() {
        let ws = NSWorkspace.shared
        for app in ws.runningApplications {
            guard app.activationPolicy == .regular else { continue }
            let appElement = AXUIElementCreateApplication(app.processIdentifier)
            var windows: CFTypeRef?
            AXUIElementCopyAttributeValue(appElement, kAXWindowsAttribute as CFString, &windows)

            if let windowArray = windows as? [AXUIElement] {
                for window in windowArray {
                    var minimized: CFTypeRef?
                    AXUIElementCopyAttributeValue(window, kAXMinimizedAttribute as CFString, &minimized)
                    let isWindowMinimized = (minimized as? Bool) ?? false

                    if isMinimizedState {
                        if isWindowMinimized {
                            AXUIElementSetAttributeValue(window, kAXMinimizedAttribute as CFString, false as CFTypeRef)
                        }
                    } else {
                        if !isWindowMinimized {
                            AXUIElementSetAttributeValue(window, kAXMinimizedAttribute as CFString, true as CFTypeRef)
                        }
                    }
                }
            }
        }
        isMinimizedState.toggle()
    }
}
