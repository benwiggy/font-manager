#!/usr/bin/swift

// Command Line Tool to register and unregister (enable/disable) fonts on macOS.
// Fonts can be registered from any location. They do not need to be in the 
// standard font folders, e.g. /Library/Fonts.

// This script was generated by Code CoPilot AI...!!!

// v1.1. Now lists all registered fonts.


import Foundation
import CoreText
import AppKit

enum FontAction: String {
    case register = "register"
    case unregister = "unregister"
    case list = "list"
}

func registerFont(withPath path: String) -> Bool {
    let fontURL = URL(fileURLWithPath: path)
    let fontURLs = [fontURL] as CFArray

    var registrationSuccessful = true
    CTFontManagerRegisterFontURLs(fontURLs, .persistent, true) { (urls, finished) -> Bool in
        if !finished {
            print("Failed to register font at path: \(path)")
            registrationSuccessful = false
        }
        return finished
    }

    if registrationSuccessful {
        print("Successfully registered font at path: \(path)")
    }
    return registrationSuccessful
}

func unregisterFont(withPath path: String) -> Bool {
    let fontURL = URL(fileURLWithPath: path)
    let fontURLs = [fontURL] as CFArray

    var unregistrationSuccessful = true
    CTFontManagerUnregisterFontURLs(fontURLs, .persistent) { (urls, finished) -> Bool in
        if !finished {
            print("Failed to unregister font at path: \(path)")
            unregistrationSuccessful = false
        }
        return finished
    }

    if unregistrationSuccessful {
        print("Successfully unregistered font at path: \(path)")
    }
    return unregistrationSuccessful
}

func listInstalledFonts() {
    let fontManager = NSFontManager.shared
    let fontFamilies = fontManager.availableFontFamilies

    for family in fontFamilies {
        print(family)
        if let fontNames = fontManager.availableMembers(ofFontFamily: family) {
            for font in fontNames {
                if let fontName = font.first as? String {
                    print("\t \(fontName)")
                }
            }
        }
    }
}

func printUsage() {
    print("Usage: font-manager.swift [register|unregister /path/to/font.ttf] | list")
}

// Main execution
let arguments = CommandLine.arguments

if arguments.count < 2 || arguments.count > 3 {
    printUsage()
    exit(1)
}

let action = arguments[1]
let fontPath = arguments.count == 3 ? arguments[2] : nil

guard let fontAction = FontAction(rawValue: action) else {
    printUsage()
    exit(1)
}

let result: Bool

switch fontAction {
case .register:
    guard let fontPath = fontPath else {
        printUsage()
        exit(1)
    }
    // Check if the font file exists
    let fileManager = FileManager.default
    guard fileManager.fileExists(atPath: fontPath) else {
        print("Font file not found at path: \(fontPath)")
        exit(1)
    }

    // Check if the font file has the correct permissions
    do {
        let attributes = try fileManager.attributesOfItem(atPath: fontPath)
        if let permissions = attributes[.posixPermissions] as? NSNumber {
            let filePermissions = permissions.uint16Value
            let readable = (filePermissions & S_IRUSR != 0) && (filePermissions & S_IRGRP != 0) && (filePermissions & S_IROTH != 0)
            if !readable {
                print("Font file at path: \(fontPath) does not have read permissions for all users.")
                exit(1)
            }
        }
    } catch {
        print("Failed to get attributes of font file at path: \(fontPath), error: \(error)")
        exit(1)
    }

    result = registerFont(withPath: fontPath)
case .unregister:
    guard let fontPath = fontPath else {
        printUsage()
        exit(1)
    }
    result = unregisterFont(withPath: fontPath)
case .list:
    listInstalledFonts()
    exit(0)
}

if result {
    exit(0)
} else {
    exit(1)
}
