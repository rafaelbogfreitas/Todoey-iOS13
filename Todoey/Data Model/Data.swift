//
//  Data.swift
//  Todoey
//
//  Created by Rafael Freitas on 02/01/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
