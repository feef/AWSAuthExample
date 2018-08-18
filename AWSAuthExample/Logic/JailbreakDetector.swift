//
//  JailbreakDetector.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 6/2/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import UIKit

// Adapted from https://medium.com/@pinmadhon/how-to-check-your-app-is-installed-on-a-jailbroken-device-67fa0170cf56
struct JailbreakDetector {
    
    #if IS_SIMULATOR
    
    static func isDeviceJailbroken() -> Bool {
        return false
    }
    
    #else
    
    static func isDeviceJailbroken() -> Bool {
        // Check 1 : existence of files that are common for jailbroken devices
        if FileManager.default.fileExists(atPath: "/Applications/Cydia.app")
            || FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib")
            || FileManager.default.fileExists(atPath: "/bin/bash")
            || FileManager.default.fileExists(atPath: "/usr/sbin/sshd")
            || FileManager.default.fileExists(atPath: "/etc/apt")
            || FileManager.default.fileExists(atPath: "/private/var/lib/apt/")
            || UIApplication.shared.canOpenURL(URL(string:"cydia://package/com.example.package")!)
        {
            return true
        }
        
        // Check 2 : Reading and writing in system directories (sandbox violation)
        let stringToWrite = "Jailbreak Test"
        do
        {
            try stringToWrite.write(toFile:"/private/JailbreakTest.txt", atomically:true, encoding:String.Encoding.utf8)
            //Device is jailbroken
            return true
        }
        catch
        {
            return false
        }
    }
    
    #endif
    
}
