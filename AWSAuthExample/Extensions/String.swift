//
//  String.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/29/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import Foundation

extension String {
    var containsOnlyDigits: Bool {
        return !contains { !"0123456789".contains($0) }
    }
}
