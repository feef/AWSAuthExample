//
//  UserLocaleSelectionView.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/30/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import UIKit

class UserLocaleSelectionView: UIView {
    lazy var pickerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .nabBarTitle
        button.tintColor = .greenyBlue
        button.setImage(#imageLiteral(resourceName: "dropDownArrow"), for: .normal)
        button.setTitleColor(.greenyBlue, for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -6)
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    lazy var areaCodeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = .placeholderText
        label.textColor = .steelGrey
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [pickerButton, areaCodeLabel])
        stackView.backgroundColor = .clear
        stackView.distribution = .fillProportionally
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: Init
    
    init() {
        super.init(frame: .zero)
        sharedSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedSetup()
    }
    
    private func sharedSetup() {
        backgroundColor = .clear
        addSubview(stackView)
        stackView.addFitToParentContraints()
    }
}
