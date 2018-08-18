//
//  AWSCognitoIdentityUserAttributeType.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/11/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider

extension AWSCognitoIdentityUserAttributeType {
    enum AttributeKey: String {
        case
            phone = "phone_number",
            firstName = "given_name",
            lastName = "family_name",
            locale = "locale"
    }
    
    convenience init(key attributeKey: AttributeKey, value: String) {
        self.init(name: attributeKey.rawValue, value: value)
    }
}


