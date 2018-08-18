//
//  Link.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/21/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import Foundation

class Link<Element> {
    let current: Element
    var next: Link<Element>?
    
    init(with element: Element) {
        current = element
    }
}
