//
//  SafeJsonObject.swift
//  Find Pics
//
//  Created by Aditya Tanna on 6/19/17.
//  Copyright © 2017 Tanna Inc. All rights reserved.
//

import Foundation

class SafeJsonObject: NSObject {
    override func setValue(_ value: Any?, forKey key: String) {
        let selectorString = "set\(key.uppercased().characters.first!)\(String(key.characters.dropFirst())):"
        let selector = Selector(selectorString)
        if responds(to: selector) {
            super.setValue(value, forKey: key)
        }
    }
}
