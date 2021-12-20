//
//  TodoListStorage.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 06.07.2021.
//

import CoreData
import Foundation

class MOTodoListCache: TodoListCache {

    static let instance = MOTodoListCache()

    private var logger: Logger?

    private var mainContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    private lazy var persistentContainer: NSPersistentContainer = {
        let bundle = Bundle(for: type(of: self))
        let persistentContainerName = "TodoList"

        guard let modelURL = bundle.url(forResource: persistentContainerName, withExtension: "momd"),
              let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            return NSPersistentContainer()
        }

        let container = NSPersistentContainer(name: persistentContainerName,
                                              managedObjectModel: managedObjectModel)

        container.loadPersistentStores(completionHandler: { (_, error) in
            container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy

            if let error = error {
                self.logger?.log(error: error)
            }
        })
        return container
    }()

    private init() { }

    var isDirty: Bool {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: TombstoneMO.name)
        let tombstoneCount: Int = (try? mainContext.count(for: fetchRequest)) ?? 0

        return todoList.filter { $0.isDirty }.count > 0 || tombstoneCount > 0
    }

    var todoList: [TodoItem] {
        let fetchRequest: NSFetchRequest<TodoItemMO> = TodoItemMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor.init(key: "createdAt", ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            let todoItemMOList = try mainContext.fetch(fetchRequest)

            return todoItemMOList.map { $0.todoItem }
        } catch {
            logger?.log(error: error)
            return []
        }
    }

    var tombstones: [Tombstone] {
        let fetchRequest: NSFetchRequest<TombstoneMO> = TombstoneMO.fetchRequest()

        do {
            let tombstoneMOList = try mainContext.fetch(fetchRequest)

            return tombstoneMOList.map { tombstoneMO in
                Tombstone(itemId: tombstoneMO.itemId ?? "", deletedAt: tombstoneMO.deletedAt ?? Date())
            }
        } catch {
            logger?.log(error: error)
            return []
        }
    }

    func insert(_ todoItem: TodoItem, _ completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()

        backgroundContext.perform { [weak self] in
            let todoItemMO = TodoItemMO(entity: TodoItemMO.entity(), insertInto: backgroundContext)

            todoItemMO.setDataFrom(todoItem)

            do {
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                self?.logger?.log(error: error)
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

                    todoItemMO.setDataFrom(todoItem)
                }
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                self?.logger?.log(error: error)
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
                self?.logger?.log(error: error)
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }

    func insert(tombstone: Tombstone, _ completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()

        backgroundContext.perform { [weak self] in
            let tombstoneMO = TombstoneMO(entity: TombstoneMO.entity(), insertInto: backgroundContext)

            tombstoneMO.itemId = tombstone.itemId
            tombstoneMO.deletedAt = tombstone.deletedAt

            do {
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                self?.logger?.log(error: error)
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }

    func clearTombstones(_ completion: @escaping (Error?) -> Void) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: TombstoneMO.name)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        backgroundContext.perform { [weak self] in
            do {
                try backgroundContext.execute(deleteRequest)
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                self?.logger?.log(error: error)
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
                        todoItemMO.setDataFrom(todoItem)
                    }
                }
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch let error as NSError {
                self?.logger?.log(error: error)
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }
    }

    func setLogger(_ logger: Logger) {
        self.logger = logger
    }
}
