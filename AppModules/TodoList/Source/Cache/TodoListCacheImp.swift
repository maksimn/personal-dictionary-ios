//
//  TodoListStorage.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 06.07.2021.
//

import CoreData
import CoreModule
import Foundation

class TodoListCacheImp: TodoListCache {

    private let container: TodoListPersistentContainer
    private let logger: SLogger

    private var mainContext: NSManagedObjectContext {
        container.persistentContainer.viewContext
    }

    private var persistentContainer: NSPersistentContainer {
        container.persistentContainer
    }

    init(container: TodoListPersistentContainer,
         logger: SLogger) {
        self.container = container
        self.logger = logger
    }

    var isDirty: Bool {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: TombstoneMO.name)
        let tombstoneCount: Int = (try? mainContext.count(for: fetchRequest)) ?? 0

        return items.filter { $0.isDirty }.count > 0 || tombstoneCount > 0
    }

    var items: [TodoItem] {
        let fetchRequest: NSFetchRequest<TodoItemMO> = TodoItemMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor.init(key: "createdAt", ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            let todoItemMOList = try mainContext.fetch(fetchRequest)

            return todoItemMOList.map { $0.todoItem }
        } catch {
            logger.log("\(error)")
            return []
        }
    }

    var completedItemCount: Int {
        items.filter({ $0.isCompleted }).count
    }

    func insert(_ todoItem: TodoItem, _ completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()

        backgroundContext.perform { [weak self] in
            let todoItemMO = TodoItemMO(entity: TodoItemMO.entity(), insertInto: backgroundContext)

            todoItemMO.set(todoItem)

            do {
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                self?.logger.log("\(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }

    func update(_ todoItem: TodoItem, _ completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        let predicate = NSPredicate.init(format: "id = '\(todoItem.id)'")
        let fetchRequest: NSFetchRequest<TodoItemMO> = TodoItemMO.fetchRequest()

        fetchRequest.predicate = predicate

        backgroundContext.perform { [weak self] in
            do {
                let array = try backgroundContext.fetch(fetchRequest)

                if array.count > 0 {
                    let todoItemMO = array[0]

                    todoItemMO.set(todoItem)
                }
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                self?.logger.log("\(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }

    func delete(_ todoItem: TodoItem, _ completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        let predicate = NSPredicate.init(format: "id = '\(todoItem.id)'")
        let fetchRequest: NSFetchRequest<TodoItemMO> = TodoItemMO.fetchRequest()

        fetchRequest.predicate = predicate

        backgroundContext.perform { [weak self] in
            do {
                let array = try backgroundContext.fetch(fetchRequest)

                if array.count > 0 {
                    let todoItemMO = array[0]

                    backgroundContext.delete(todoItemMO)
                }
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                self?.logger.log("\(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }

    func replaceWith(_ todoList: [TodoItem], _ completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: TodoItemMO.name)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        backgroundContext.perform { [weak self] in
            do {
                try backgroundContext.execute(deleteRequest)
                todoList.forEach { todoItem in
                    if let todoItemMO = NSEntityDescription.insertNewObject(forEntityName: TodoItemMO.name,
                                                                            into: backgroundContext) as? TodoItemMO {
                        todoItemMO.set(todoItem)
                    }
                }
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch let error as NSError {
                self?.logger.log("\(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }
}
