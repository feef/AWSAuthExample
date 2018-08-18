//
//  UserLocaleSelectionViewPopulator.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 5/20/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import Foundation

struct UserLocaleSelectionViewPopulator {
    static func populate(_ userLocaleSelectionView: UserLocaleSelectionView, with userLocale: UserLocale = .bestUserLocale()) {
        userLocaleSelectionView.areaCodeLabel.text = userLocale.phoneNumberCode
        userLocaleSelectionView.pickerButton.setTitle(userLocale.abbreviation, for: .normal)
    }
}
