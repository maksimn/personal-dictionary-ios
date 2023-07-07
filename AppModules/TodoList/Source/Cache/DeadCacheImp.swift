//
//  TodoListCache.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 08.07.2021.
//

struct DeadCacheImp: DeadCache {

    private let cbDeadCache: CBDeadCache

    init(cbDeadCache: CBDeadCache) {
        self.cbDeadCache = cbDeadCache
    }

    var items: [Tombstone] {
        get throws {
            do {
                return try cbDeadCache.items
            } catch {
                throw DeadCacheError.getItemsError(error)
            }
        }
    }

    func insert(_ item: Tombstone) async throws {
        try await withCheckedThrowingContinuation { continuation in
            cbDeadCache.insert(tombstone: item) { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: DeadCacheError.insertError(error))
                }
            }
        }
    }

    func clear() async throws {
        try await withCheckedThrowingContinuation { continuation in
            cbDeadCache.clear { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: DeadCacheError.clearError(error))
                }
            }
        }
    }
}
