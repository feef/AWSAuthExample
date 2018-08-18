//
//  NSError.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 5/21/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import Foundation

extension NSError {
    var awsErrorTitle: String? {
        return localizedString(forKey: "__type")
    }
    
    var awsErrorMessage: String? {
        return localizedString(forKey: "message")
    }
    
    private func localizedString(forKey key: String) -> String? {
        guard let string = userInfo[key] as? String else {
            return nil
        }
        // TODO: Perhaps revise this for proper localization
        return NSLocalizedString(string, comment: "")
    }
}
