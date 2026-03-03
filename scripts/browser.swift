#!/usr/bin/env swift
// Toggle the default browser between Firefox and Chrome on macOS.

// Toggle default browser between Firefox and Chrome
// Compile: swiftc -O browser.swift -o browser

import Foundation
import CoreServices

let firefox = "org.mozilla.firefox"
let chrome = "com.google.chrome"

func getCurrentBrowser() -> String? {
    LSCopyDefaultHandlerForURLScheme("https" as CFString)?.takeRetainedValue() as String?
}

func getBrowserName(_ bundleId: String) -> String {
    if bundleId.lowercased().contains("firefox") { return "Firefox" }
    if bundleId.lowercased().contains("chrome") { return "Chrome" }
    return bundleId
}

func setBrowser(_ bundleId: String) {
    _ = LSSetDefaultHandlerForURLScheme("http" as CFString, bundleId as CFString)
    _ = LSSetDefaultHandlerForURLScheme("https" as CFString, bundleId as CFString)
}

// Toggle
let before = getCurrentBrowser() ?? ""
let isFirefox = before.lowercased().contains("firefox")
let newBrowser = isFirefox ? chrome : firefox

setBrowser(newBrowser)

// Poll for change (up to 30 seconds)
for _ in 0..<300 {
    usleep(100_000) // 100ms
    if let after = getCurrentBrowser(), after != before {
        print("Default browser: \(getBrowserName(after))")
        exit(0)
    }
}

