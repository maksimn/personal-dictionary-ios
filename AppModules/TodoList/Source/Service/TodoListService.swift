//
//  TodoListService.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

protocol TodoListService {

    func getTodos() async throws -> [Todo]

    func createRemote(_ todo: Todo) async throws

    func updateRemote(_ todo: Todo) async throws

    func deleteRemote(_ todo: Todo) async throws

    func syncWithRemote(_ deleted: [String], _ other: [Todo]) async throws -> [Todo]
}
