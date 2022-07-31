//
//  TombstoneMO.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 06.07.2021.
//

import CoreData

@objc(TombstoneMO)
class TombstoneMO: NSManagedObject {

    @NSManaged var deletedAt: Date?
    @NSManaged var itemId: String?

    static var name: String {
        "TombstoneMO"
    }

    @nonobjc class func fetchRequest() -> NSFetchRequest<TombstoneMO> {
        return NSFetchRequest<TombstoneMO>(entityName: TombstoneMO.name)
    }
}
