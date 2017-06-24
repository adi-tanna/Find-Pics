//
//  File.swift
//  Find Pics
//
//  Created by Aditya Tanna on 6/24/17.
//  Copyright © 2017 Tanna Inc. All rights reserved.
//

import Foundation

class Image: SafeJsonObject {
    
    var title: String?
    var link: String?
    var mime: String?
    
    override func setValue(_ value: Any?, forKey key: String) {
        super.setValue(value, forKey: key)
    }
}
