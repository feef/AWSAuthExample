//
//  AWSCognitoIdentityPasswordAuthenticationDetails.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/25/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import AWSCognitoIdentityProvider

extension AWSCognitoIdentityPasswordAuthenticationDetails {
    convenience init?(username: String, passwordFromConstants constants: AuthenticationConstants = .defaultConstants) {
        self.init(username: username, password: constants.password)
    }
}
