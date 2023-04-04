//
//  MainListLogAction.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 06.02.2023.
//

extension App {

    enum LogAction {
        case insertTodoIntoCacheStart(Todo)
        case insertTodoIntoCacheSuccess(Todo)
        case insertTodoIntoCacheError(Todo, Error)

        case updateTodoInCacheStart(Todo)
        case updateTodoInCacheSuccess(Todo)
        case updateTodoInCacheError(Todo, Error)

        case deleteTodoInCacheStart(Todo)
        case deleteTodoInCacheSuccess(Todo)
        case deleteTodoInCacheError(Todo, Error)

        case createRemoteTodoStart(Todo)
        case createRemoteTodoSuccess(Todo)
        case createRemoteTodoError(Todo, Error)

        case updateRemoteTodoStart(Todo)
        case updateRemoteTodoSuccess(Todo)
        case updateRemoteTodoError(Todo, Error)

        case deleteRemoteTodoStart(Todo)
        case deleteRemoteTodoSuccess(Todo)
        case deleteRemoteTodoError(Todo, Error)

        case replaceAllTodosInCacheStart
        case replaceAllTodosInCacheSuccess
        case replaceAllTodosInCacheError(Error)
    }
}
