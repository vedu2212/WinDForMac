# WinDForMac

A lightweight, native macOS background utility built in Swift that replicates the Windows `Win + D` behavior.

Pressing `Option + D` instantly minimizes all visible application windows. Pressing `Option + D` again perfectly restores all minimized windows to their original states.

Runs silently in the macOS Menu Bar. Optimized for Apple Silicon (built and tested on M4 Pro).

## How It Works
Instead of using AppleScript (which struggles with tracking window states), this app utilizes the native macOS Accessibility API (`AXUIElement`).
* State 1: Iterates through all active applications and sets their `kAXMinimizedAttribute` to `true`.
* State 2: Scans for all minimized windows across the system and sets their `kAXMinimizedAttribute` to `false`, bringing back everything that was hidden (including windows you may have minimized manually).

## Installation

Because this app uses Accessibility APIs to control other windows, Apple's App Sandbox prevents it from being distributed on the Mac App Store. You must install it directly.

1. Go to the Releases tab on the right side of this GitHub page and download the latest `WinDForMac.app.zip` file.
2. Unzip the file and drag `WinDForMac.app` into your Mac's Applications folder.
3. Double-click the app to open it. (Note: Because I am an independent developer, macOS might show a warning. If it blocks you, go to System Settings > Privacy & Security, scroll down, and click "Open Anyway" next to the app).
4. You will see a "Win+D" icon appear in your top-right Menu Bar.

## Required Permissions (Crucial)
macOS requires explicit permission for an app to control your windows.

1. Press `Option + D` once to trigger the macOS security prompt.
2. Open System Settings > Privacy & Security > Accessibility.
3. Find WinDForMac in the list and toggle the switch to ON.
4. Restart the app: Click the icon in your Menu Bar, click Quit, and then reopen the app from your Applications folder.

The `Option + D` hotkey will now work globally.

## Launch on Startup
To have the hotkey available automatically when you turn on your Mac:
1. Open System Settings > General > Login Items.
2. Under "Open at Login", click the + button.
3. Select `WinDForMac` from your Applications folder.

## ⚠️ Troubleshooting: "App Cannot Be Opened"
Since this app is from an independent developer, macOS might block it initially with a "Malware" or "Unidentified Developer" warning. This is normal for apps not downloaded from the App Store.

### How to Fix (Gatekeeper Bypass):
1. Right-Click Method (Fastest): Locate `WinDForMac.app` in your Applications folder. Right-click (or Control-click) the icon and select Open. In the popup that appears, click the Open button. You only need to do this once.
2. System Settings Method: If the above doesn't work, go to System Settings > Privacy & Security. Scroll down to the Security section where you see a message about `WinDForMac` being blocked. Click Open Anyway and enter your password.

### Shortcut Not Working?
If the app is running in your Menu Bar but the hotkey isn't minimizing windows:
1. Go to System Settings > Privacy & Security > Accessibility.
2. If `WinDForMac` is already there, click the minus (-) button to remove it completely.
3. Click the plus (+) button or drag the app into the list and toggle it N.
4. Important: Quit the app from the Menu Bar and reopen it for the permissions to take effect.

//
//  README.md
//  WinDForMac
//
//  Created by Vedant Vyas on 3/23/26.
//
