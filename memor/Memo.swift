//
//  Memo.swift
//  memor
//


import Foundation
import RealmSwift

class Memo: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var date = Date()
}
