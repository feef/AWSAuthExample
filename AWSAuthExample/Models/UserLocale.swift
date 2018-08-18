//
//  UserLocale.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/29/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import Foundation

enum UserLocale: String {
    case US, ES
    
    private static var defaultLanguageCode: String = {
        return Locale.autoupdatingCurrent.languageCode ?? "en"
    }()
    
    static let all: [UserLocale] = [.US, .ES]
    
    static func bestUserLocale(for locale: Locale = .autoupdatingCurrent) -> UserLocale {
        // TODO: Remove hack that forces only spanish
        return .ES // all.first(where: { $0.rawValue == locale.regionCode }) ?? .US
    }
    
    func locale(withIdealLanguageCode languageCode: String = UserLocale.defaultLanguageCode) -> Locale {
        let identifier = Locale.identifier(fromComponents: [CFLocaleKey.languageCode.rawValue as String: languageCode, CFLocaleKey.countryCode.rawValue as String: rawValue])
        return Locale(identifier: identifier)
    }
    
    var name: String {
        return locale().localizedString(forRegionCode: rawValue)!
    }
    
    var abbreviation: String {
        // TODO: Remove hack that allows login/signup for spanish numbers
        if self == .ES { return UserLocale.US.abbreviation }
        return rawValue
    }
    
    var phoneNumberCode: String {
        switch self {
            case .US:
                return "+1"
            case .ES:
                return "+34"
        }
    }
    
    func phoneNumberIsValid(_ phoneNumber: String) -> Bool {
        guard phoneNumber.containsOnlyDigits else {
            return false
        }
        let phoneNumberLength = phoneNumber.count
        switch self {
            case .US:
                return phoneNumber.first != "0" && phoneNumberLength == 10
            case .ES:
                return phoneNumberLength == 9
        }
    }
}
