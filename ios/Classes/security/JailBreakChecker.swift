//
//  JailBreakChecker.swift
//  Pods
//
//  Created by Umair Khan on 14/11/2025.
//

import Foundation
import Foundation
import UIKit
import Darwin

extension UIDevice {
    var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }

    var isJailBrokenCustom: Bool {
        if UIDevice.current.isSimulator { return false }
        if JailBrokenHelper.hasCydiaInstalled() { return true }
        if JailBrokenHelper.isContainsSuspiciousApps() { return true }
        if JailBrokenHelper.isSuspiciousSystemPathsExists() { return true }
        if JailBrokenHelper.canEditSystemFiles() { return true }
        if JailBrokenHelper.hasSandboxViolation() { return true }
        if JailBrokenHelper.checkDYLD() { return true }
        return false
    }
}

private struct JailBrokenHelper {
    static func hasCydiaInstalled() -> Bool {
        let urls = ["cydia://", "sileo://", "zbra://"]
        for s in urls {
            if let url = URL(string: s),
               UIApplication.shared.canOpenURL(url) {
                return true
            }
        }
        return false
    }

    static func isContainsSuspiciousApps() -> Bool {
        for path in suspiciousAppsPathToCheck {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }

    static func isSuspiciousSystemPathsExists() -> Bool {
        for path in suspiciousSystemPathsToCheck {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }

    static func canEditSystemFiles() -> Bool {
        let jailBreakText = "Developer Insider"
        let path = "/private/" + jailBreakText

        do {
            try jailBreakText.write(toFile: path, atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }

    static func hasSandboxViolation() -> Bool {
        let testPath = "/private/sandbox_test"
        do {
            try "sandbox_test".write(toFile: testPath,
                                     atomically: true,
                                     encoding: .utf8)
            try FileManager.default.removeItem(atPath: testPath)
            return true
        } catch {
            return false
        }
    }

    static func checkDYLD() -> Bool {
        let suspiciousLibraries = [
            "SubstrateLoader.dylib",
            "libhooker.dylib",
            "SubstrateBootstrap.dylib",
            "libsubstitute.dylib",
            "libellekit.dylib"
        ]

        for library in suspiciousLibraries {
            if dlopen(library, RTLD_NOW) != nil {
                return true
            }
        }
        return false
    }

    static var suspiciousAppsPathToCheck: [String] {
        return [
            "/Applications/Cydia.app",
            "/Applications/blackra1n.app",
            "/Applications/FakeCarrier.app",
            "/Applications/Icy.app",
            "/Applications/IntelliScreen.app",
            "/Applications/MxTube.app",
            "/Applications/RockApp.app",
            "/Applications/SBSettings.app",
            "/Applications/WinterBoard.app",

            "/Applications/Palera1n.app",
            "/Applications/Sileo.app",
            "/Applications/Zebra.app",
            "/Applications/TrollStore.app",
            "/var/containers/Bundle/Application/TrollStore.app",

            "/Applications/checkra1n.app",

            "/var/jb/Applications/Cydia.app",
            "/var/jb/Applications/Sileo.app",
            "/var/jb/Applications/Zebra.app"
        ]
    }

    static var suspiciousSystemPathsToCheck: [String] {
        return [
            "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
            "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
            "/private/var/lib/apt",
            "/private/var/lib/cydia",
            "/private/var/mobile/Library/SBSettings/Themes",
            "/private/var/stash",
            "/private/var/tmp/cydia.log",
            "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
            "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
            "/usr/bin/sshd",
            "/usr/libexec/sftp-server",
            "/usr/sbin/sshd",
            "/etc/apt",
            "/bin/bash",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",

            "/var/jb",
            "/var/binpack",
            "/var/containers/Bundle/tweaksupport",
            "/var/mobile/Library/palera1n",
            "/var/mobile/Library/xyz.willy.Zebra",
            "/var/lib/undecimus",

            "/var/jb/basebin",
            "/var/jb/usr",
            "/var/jb/etc",
            "/var/jb/Library",
            "/var/jb/.installed_palera1n",
            "/var/binpack/Applications",
            "/var/binpack/usr",

            "/var/containers/Bundle/Application/trollstorehelper",
            "/var/containers/Bundle/trollstore",

            "/var/jb/preboot",
            "/var/jb/var"
        ]
    }
}

// Obj-C ke liye visible wrapper
@objc(JailBreakChecker)
public class JailBreakChecker: NSObject {
    @objc public static func isJailBroken() -> Bool {
        return UIDevice.current.isJailBrokenCustom
    }
}
