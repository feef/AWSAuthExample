//
//  DropDownAlertViewPopulator.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 5/27/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import UIKit

struct DropDownAlertViewPopulator {
    enum AlertViewStyle {
        case noNetwork, error(String)
        
        var icon: UIImage {
            switch self {
                case .noNetwork:
                    return #imageLiteral(resourceName: "errorIcon")
                case .error:
                    return #imageLiteral(resourceName: "X")
            }
        }
        var text: String {
            switch self {
                case .noNetwork:
                    return LocalizedString.noNetworkAlertTitle
                case .error(let text):
                    return text
            }
        }
        var backgroundColor: UIColor {
            switch self {
                case .noNetwork:
                    return .steelGrey
                case .error:
                    return .fadedRed
            }
        }
    }
    
    static func populate(_ dropDownAlertView: DropDownAlertView, with style: AlertViewStyle) {
        populate(dropDownAlertView, withIcon: style.icon, text: style.text, backgroundColor: style.backgroundColor)
    }
    
    static func populate(_ dropDownAlertView: DropDownAlertView, withIcon icon: UIImage, text: String, backgroundColor: UIColor) {
        style(dropDownAlertView)
        dropDownAlertView.imageView.image = icon
        dropDownAlertView.label.text = text
        dropDownAlertView.backgroundColor = backgroundColor
    }
    
    private static func style(_ dropDownAlertView: DropDownAlertView) {
        dropDownAlertView.imageView.tintColor = .paleGrey
        dropDownAlertView.label.textColor = .paleGrey
        dropDownAlertView.label.font = .bodyText
    }
}
