//
//  SyncService.swift
//  TodoList
//
//  Created by Maksim Ivanov on 11.07.2023.
//

protocol SyncService {

    func syncWithRemote(_ deleted: [String], _ other: [Todo]) async throws -> [Todo]
}
