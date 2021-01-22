//
//  Category.swift
//  Todoey
//
//  Created by Rafael Freitas on 03/01/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
