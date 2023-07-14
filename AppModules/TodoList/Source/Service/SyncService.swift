//
//  TodoListService.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 14.08.2022.
//

import CoreModule

protocol SyncService {

    func syncWithRemoteTodos(_ dirtyData: DirtyData) async throws -> [Todo]
}

struct SyncServiceImp: SyncService {

    private let urlString: String
    private let headers: [String: String]
    private let httpClient: HttpClientAdapter

    init(urlString: String,
         headers: [String: String],
         httpClient: HttpClientAdapter) {
        self.urlString = urlString
        self.headers = headers
        self.httpClient = httpClient
    }

    func syncWithRemoteTodos(_ dirtyData: DirtyData) async throws -> [Todo] {
        let dtos: [TodoDTO] = try await httpClient.sendAndDecode(
            Http(
                urlString: "\(urlString)/tasks/",
                method: "PUT",
                headers: headers
            ),
            SyncTodoListRequestData(
                deleted: dirtyData.tombstones.map { $0.todoId },
                other: dirtyData.dirtyTodos.map { TodoDTO($0) }
            )
        )

        return dtos.mapAndSort()
    }
}
