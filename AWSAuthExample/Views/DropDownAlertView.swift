//
//  DropDownAlertView.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 5/27/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import UIKit

class DropDownAlertView: UIView {
    enum State {
        case visible, hidden, unknown
    }
    
    private static let defaultHeight = CGFloat(29)
    
    let imageView = UIImageView()
    let label = UILabel()
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        return stackView
    }()
    lazy var heightConstraint: NSLayoutConstraint = heightAnchor.constraint(equalToConstant: DropDownAlertView.defaultHeight)
    
    var state = State.unknown
    
    init() {
        super.init(frame: .zero)
        sharedSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedSetup()
    }
    
    private func sharedSetup() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        heightConstraint.isActive = true
        stackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor).isActive = true
        stackView.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
