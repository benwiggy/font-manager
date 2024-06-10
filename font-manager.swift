#!/usr/bin/swift

// Command Line Tool to register and unregister (enable/disable) fonts on macOS.
// Fonts can be registered from any location. They do not need to be in the 
// standard font folders, e.g. /Library/Fonts.

// This script was generated by Code CoPilot AI...!!!

// v1.0. 

import Foundation
import CoreText

enum FontAction: String {
    case register = "register"
    case unregister = "unregister"
}

func registerFont(withPath path: String) -> Bool {
    let fontURL = URL(fileURLWithPath: path)

    var error: Unmanaged<CFError>?
    let success = CTFontManagerRegisterFontsForURL(fontURL as CFURL, .persistent, &error)

    if success {
        print("Successfully registered font at path: \(path)")
        return true
    } else {
        if let error = error {
            print("Failed to register font at path: \(path), error: \(error.takeUnretainedValue())")
        }
        return false
    }
}

func unregisterFont(withPath path: String) -> Bool {
    let fontURL = URL(fileURLWithPath: path)

    var error: Unmanaged<CFError>?
    let success = CTFontManagerUnregisterFontsForURL(fontURL as CFURL, .persistent, &error)

    if success {
        print("Successfully unregistered font at path: \(path)")
        return true
    } else {
        if let error = error {
            print("Failed to unregister font at path: \(path), error: \(error.takeUnretainedValue())")
        }
        return false
    }
}

func printUsage() {
    print("Usage: font-manager.swift [register|unregister] /path/to/font.ttf")
}

// Main execution
let arguments = CommandLine.arguments

if arguments.count != 3 {
    printUsage()
    exit(1)
}

let action = arguments[1]
let fontPath = arguments[2]

guard let fontAction = FontAction(rawValue: action) else {
    printUsage()
    exit(1)
}

let result: Bool

switch fontAction {
case .register:
    result = registerFont(withPath: fontPath)
case .unregister:
    result = unregisterFont(withPath: fontPath)
}

if result {
    exit(0)
} else {
    exit(1)
}
