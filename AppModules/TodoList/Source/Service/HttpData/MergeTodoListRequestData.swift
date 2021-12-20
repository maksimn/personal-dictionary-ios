//
//  MergeTodoListRequestData.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 26.06.2021.
//

struct MergeTodoListRequestData: Encodable {
    let deleted: [String]
    let other: [TodoItemDTO]
}
