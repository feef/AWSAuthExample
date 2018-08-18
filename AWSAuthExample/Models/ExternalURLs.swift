//
//  ExternalURLs.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 6/2/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import Foundation

class ExternalURLs {
    let deviceSecurityHelp: URL
    
    static let defaultURLs = ExternalURLs()!
    
    convenience init?(plistName: String = "ExternalURLs") {
        guard let plistContents = PlistReader.plistContentsFromFile(named: plistName) else {
            return nil
        }
        self.init(plistContents)
    }
    
    init?(_ dictionary: [String: Any]) {
        guard
            let deviceSecurityHelpString = dictionary["deviceSecurityHelp"] as? String,
            let deviceSecurityHelpURL = URL(string: deviceSecurityHelpString)
        else {
            return nil
        }
        deviceSecurityHelp = deviceSecurityHelpURL
    }
}
