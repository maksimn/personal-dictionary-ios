//
//  SyncTodoListRequestData.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 26.06.2021.
//

struct SyncTodoListRequestData: Encodable {
    let deleted: [String]
    let other: [TodoDTO]
}
