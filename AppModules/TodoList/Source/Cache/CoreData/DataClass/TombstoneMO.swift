//
//  TombstoneMO.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 06.07.2021.
//

import Foundation
import CoreData

@objc(TombstoneMO)
public class TombstoneMO: NSManagedObject {

    @NSManaged public var deletedAt: Date?
    @NSManaged public var itemId: String?

    static var name: String {
        "TombstoneMO"
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TombstoneMO> {
        return NSFetchRequest<TombstoneMO>(entityName: TombstoneMO.name)
    }
}
