//
//  AppearanceManager.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/8/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import UIKit

struct AppearanceManager {
    static func styleApp() {
        styleNavBar()
        styleBarButtonItems()
    }
    
    private static func styleNavBar() {
        let appearance = UINavigationBar.appearance()
        appearance.setBackgroundImage(nil, for: .default)
        appearance.shadowImage = UIImage()
        appearance.barTintColor = .greenishTeal
        appearance.titleTextAttributes = [.font: UIFont.nabBarTitle, .foregroundColor: UIColor.white]
        appearance.backIndicatorImage = nil
    }
    
    private static func styleBarButtonItems() {
        let appearance = UIBarButtonItem.appearance()
        appearance.setTitleTextAttributes([.font: UIFont.nabBarTitle, .foregroundColor: UIColor.greenyBlue], for: .normal)
    }
}
