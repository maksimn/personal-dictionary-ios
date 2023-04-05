//
//  TodoListStorage.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 06.07.2021.
//

import CoreData
import Foundation

class TodoListCacheImp: TodoListCache {

    private lazy var container = TodoListPersistentContainer(logger: logger)
    private let logger: Logger

    private var mainContext: NSManagedObjectContext {
        container.persistentContainer.viewContext
    }

    private var persistentContainer: NSPersistentContainer {
        container.persistentContainer
    }

    init(logger: Logger) {
        self.logger = logger
    }

    var isDirty: Bool {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: TombstoneMO.name)
        let tombstoneCount: Int = (try? mainContext.count(for: fetchRequest)) ?? 0

        return todos.filter { $0.isDirty }.count > 0 || tombstoneCount > 0
    }

    var todos: [Todo] {
        let fetchRequest: NSFetchRequest<TodoMO> = TodoMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor.init(key: "createdAt", ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            let todoMOList = try mainContext.fetch(fetchRequest)

            return todoMOList.map { $0.todo }
        } catch {
            logger.log(error: error)
            return []
        }
    }

    func insert(_ todo: Todo) async throws {
        try await withCheckedThrowingContinuation { continuation in
            insert(todo) { result in
                continuation.resume(with: result)
            }
        }
    }

    func update(_ todo: Todo) async throws {
        try await withCheckedThrowingContinuation { continuation in
            update(todo) { result in
                continuation.resume(with: result)
            }
        }
    }

    func delete(_ todo: Todo) async throws {
        try await withCheckedThrowingContinuation { continuation in
            delete(todo) { result in
                continuation.resume(with: result)
            }
        }
    }

    func replaceWith(_ todoList: [Todo]) async throws {
        try await withCheckedThrowingContinuation { continuation in
            replaceWith(todoList) { result in
                continuation.resume(with: result)
            }
        }
    }

    private func insert(_ todo: Todo, _ completion: @escaping VoidCallback) {
        let backgroundContext = persistentContainer.newBackgroundContext()

        backgroundContext.perform { [weak self] in
            let todoMO = TodoMO(entity: TodoMO.entity(), insertInto: backgroundContext)

            todoMO.set(todo)

            do {
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion(.success(Void()))
                }
            } catch {
                self?.logger.log(error: error)
                DispatchQueue.main.async {
                    completion(.failure(TodoListCacheError.insertFailed(error)))
                }
            }
        }
    }

    private func update(_ todo: Todo, _ completion: @escaping VoidCallback) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        let predicate = NSPredicate.init(format: "id = '\(todo.id)'")
        let fetchRequest: NSFetchRequest<TodoMO> = TodoMO.fetchRequest()

        fetchRequest.predicate = predicate

        backgroundContext.perform { [weak self] in
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
                self?.logger.log(error: error)
                DispatchQueue.main.async {
                    completion(.failure(TodoListCacheError.updateFailed(error)))
                }
            }
        }
    }

    private func delete(_ todo: Todo, _ completion: @escaping VoidCallback) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        let predicate = NSPredicate.init(format: "id = '\(todo.id)'")
        let fetchRequest: NSFetchRequest<TodoMO> = TodoMO.fetchRequest()

        fetchRequest.predicate = predicate

        backgroundContext.perform { [weak self] in
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
                self?.logger.log(error: error)
                DispatchQueue.main.async {
                    completion(.failure(TodoListCacheError.deleteFailed(error)))
                }
            }
        }
    }

    private func replaceWith(_ todoList: [Todo], _ completion: @escaping VoidCallback) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: TodoMO.name)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        backgroundContext.perform { [weak self] in
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
                self?.logger.log(error: error)
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
