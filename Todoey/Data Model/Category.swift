//
//  Category.swift
//  Todoey
//
//  Created by Natalia Kazakova on 10/06/2019.
//  Copyright © 2019 Natalia Kazakova. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    let items = List<Item>()
}
