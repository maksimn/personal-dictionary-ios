//
//  TodoMO.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 06.07.2021.
//

import CoreData

@objc(TodoMO)
class TodoMO: NSManagedObject {

    @NSManaged var createdAt: Date?
    @NSManaged var deadline: Date?
    @NSManaged var id: String?
    @NSManaged var isCompleted: Bool
    @NSManaged var isDirty: Bool
    @NSManaged var priority: String?
    @NSManaged var text: String?
    @NSManaged var updatedAt: Date?

    static var name: String {
        "TodoMO"
    }

    @nonobjc class func fetchRequest() -> NSFetchRequest<TodoMO> {
        return NSFetchRequest<TodoMO>(entityName: TodoMO.name)
    }

    func set(_ todo: Todo) {
        self.id = todo.id
        self.text = todo.text
        self.priority = TodoDTO.mapPriority(todo.priority)
        self.deadline = todo.deadline
        self.isCompleted = todo.isCompleted
        self.createdAt = Date(timeIntervalSince1970: TimeInterval(todo.createdAt))
        self.updatedAt = Date(timeIntervalSince1970: TimeInterval(todo.updatedAt))
        self.isDirty = todo.isDirty
    }

    var todo: Todo {
        Todo(
            id: self.id ?? "",
            text: self.text ?? "",
            priority: TodoDTO.mapPriority(self.priority ?? ""),
            deadline: self.deadline,
            isCompleted: self.isCompleted,
            createdAt: self.createdAt?.integer ?? 0,
            updatedAt: self.updatedAt?.integer ?? 0,
            isDirty: self.isDirty
        )
    }
}
