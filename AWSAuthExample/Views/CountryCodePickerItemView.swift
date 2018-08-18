//
//  CountryCodePickerItemView.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 5/20/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import UIKit

class CountryCodePickerItemView: UIStackView {
    let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        return label
    }()
    
    let codeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .right
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        sharedSetup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        sharedSetup()
    }
    
    private func sharedSetup() {
        axis = .horizontal
        distribution = .fillProportionally
        addArrangedSubview(nameLabel)
        addArrangedSubview(codeLabel)
    }
}
