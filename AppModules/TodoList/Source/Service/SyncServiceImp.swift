//
//  SyncServiceImp.swift
//  TodoList
//
//  Created by Maksim Ivanov on 11.07.2023.
//

struct SyncServiceImp: SyncService {

    func syncWithRemote(_ deleted: [String], _ other: [Todo]) async throws -> [Todo] {
        []
    }
}
