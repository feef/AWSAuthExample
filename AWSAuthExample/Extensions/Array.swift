//
//  Array.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/21/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import Foundation

extension Array {
    func linkedList() -> Link<Element>? {
        let reversedArray = reversed()
        return reversedArray.reduce(nil) { (lastLink: Link<Element>?, currentElement: Element) in
            let link = Link(with: currentElement)
            if let lastLink = lastLink {
                link.next = lastLink
            }
            return link
        }
    }
}
