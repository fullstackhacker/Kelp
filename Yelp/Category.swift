//
//  Category.swift
//  Yelp
//
//  Created by Mushaheed Kapadia on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import Foundation

class Category {
    var name: String!
    var code: String!
    var isOn: Bool!
    
    init(categoryDict: [String:String]) {
        name = categoryDict["name"]
        code = categoryDict["code"]
        isOn = false
    }
}
