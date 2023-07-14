//
//  TodoListCache.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 08.07.2021.
//

import CoreData
import CoreModule
import Foundation

protocol CBTodoListCache {

    var todos: [Todo] { get throws }

    func insert(_ todo: Todo, _ completion: @escaping VoidCallback)

    func update(_ todo: Todo, _ completion: @escaping VoidCallback)

    func delete(_ todo: Todo, _ completion: @escaping VoidCallback)

    func replaceWith(_ todoList: [Todo], _ completion: @escaping VoidCallback)
}

struct CBTodoListCacheImp: CBTodoListCache {

    private let persistentContainer: NSPersistentContainer

    private var mainContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    var todos: [Todo] {
        get throws {
            try filterTodos(predicate: nil)
        }
    }

    func insert(_ todo: Todo, _ completion: @escaping VoidCallback) {
        let backgroundContext = persistentContainer.newBackgroundContext()

        backgroundContext.perform {
            let todoMO = TodoMO(entity: TodoMO.entity(), insertInto: backgroundContext)

            todoMO.set(todo)

            do {
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(.success(Void()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func update(_ todo: Todo, _ completion: @escaping VoidCallback) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        let predicate = NSPredicate.init(format: "id = '\(todo.id)'")
        let fetchRequest: NSFetchRequest<TodoMO> = TodoMO.fetchRequest()

        fetchRequest.predicate = predicate

        backgroundContext.perform {
            do {
                let array = try backgroundContext.fetch(fetchRequest)

                if array.count > 0 {
                    let todoMO = array[0]

                    todoMO.set(todo)
                }
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(.success(Void()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func delete(_ todo: Todo, _ completion: @escaping VoidCallback) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        let predicate = NSPredicate.init(format: "id = '\(todo.id)'")
        let fetchRequest: NSFetchRequest<TodoMO> = TodoMO.fetchRequest()

        fetchRequest.predicate = predicate

        backgroundContext.perform {
            do {
                let array = try backgroundContext.fetch(fetchRequest)

                if array.count > 0 {
                    let todoMO = array[0]

                    backgroundContext.delete(todoMO)
                }
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(.success(Void()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    func replaceWith(_ todoList: [Todo], _ completion: @escaping VoidCallback) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: TodoMO.name)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        backgroundContext.perform {
            do {
                try backgroundContext.execute(deleteRequest)
                todoList.forEach { todo in
                    if let todoMO = NSEntityDescription.insertNewObject(forEntityName: TodoMO.name,
                                                                            into: backgroundContext) as? TodoMO {
                        todoMO.set(todo)
                    }
                }
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(.success(Void()))
                }
            } catch let error as NSError {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    private func filterTodos(predicate: NSPredicate?) throws -> [Todo] {
        let fetchRequest: NSFetchRequest<TodoMO> = TodoMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor.init(key: "createdAt", ascending: true)

        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]

        let todoMOList = try mainContext.fetch(fetchRequest)

        return todoMOList.map { $0.todo }
    }
}
