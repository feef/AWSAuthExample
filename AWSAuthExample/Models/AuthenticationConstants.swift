//
//  AWSConstants.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/6/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import Foundation
import AWSCore

class AuthenticationConstants {
    let region: AWSRegionType
    let userPoolID: String
    let identityPoolID: String
    let clientID: String
    let registrationKey: String
    let password: String
    
    static let defaultConstants = AuthenticationConstants()!
    
    convenience init?(plistName: String = "AWSConstants") {
        guard let plistContents = PlistReader.plistContentsFromFile(named: plistName) else {
            return nil
        }
        self.init(plistContents)
    }
    
    init?(_ dictionary: [String: Any]) {
        guard
            let regionValue = dictionary["region"] as? Int,
            let region = AWSRegionType(rawValue: regionValue),
            let userPoolID = dictionary["userPoolID"] as? String,
            let identityPoolID = dictionary["identityPoolID"] as? String,
            let clientID = dictionary["clientID"] as? String,
            let registrationKey = dictionary["registrationKey"] as? String,
            let password = dictionary["password"] as? String
        else {
            return nil
        }
        self.region = region
        self.userPoolID = userPoolID
        self.identityPoolID = identityPoolID
        self.clientID = clientID
        self.registrationKey = registrationKey
        self.password = password
    }
}
