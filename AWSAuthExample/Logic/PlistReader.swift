//
//  PlistReader.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/6/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import Foundation

struct PlistReader {
    static func plistContentsFromFile(named fileName: String) -> [String: Any]? {
        guard
            let fileURL = Bundle.main.url(forResource: fileName, withExtension: "plist"),
            let data = try? Data(contentsOf: fileURL),
            let plistDictionary = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any]
        else {
            return nil
        }
        return plistDictionary
    }
}
