//
//  DropDownAlertViewDisplayer.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 5/27/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import UIKit

struct DropDownAlertViewDisplayer {
    private static let duration = 0.25
    
    static func update(_ dropDownAlertView: DropDownAlertView, toState state: DropDownAlertView.State, in view: UIView, completion: ((Bool) -> Void)? = nil) {
        let viewBounds = view.bounds
        let dropDownHeight = dropDownAlertView.heightConstraint.constant
        let alertViewSize = CGSize(width: viewBounds.width, height: dropDownHeight)
        let topInset = view.safeAreaInsets.top
        let hiddenFrame = CGRect(origin: CGPoint(x: 0, y: topInset - dropDownHeight), size: alertViewSize)
        let visibleFrame = CGRect(origin: CGPoint(x: 0, y: topInset), size: alertViewSize)
        
        if dropDownAlertView.state == .unknown {
            dropDownAlertView.frame = hiddenFrame
            view.addSubview(dropDownAlertView)
            dropDownAlertView.state = .hidden
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: [.beginFromCurrentState], animations: {
            dropDownAlertView.frame = state == .visible ? visibleFrame : hiddenFrame
        }, completion: { animationCompleted in
            dropDownAlertView.state = state
            completion?(animationCompleted)
        })
    }
}
