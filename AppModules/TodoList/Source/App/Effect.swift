//
//  Effect.swift
//  
//
//  Created by Maksim Ivanov on 10.04.2023.
//

import ComposableArchitecture

protocol Effect {

    func run() -> AppEffectTask
}

protocol TodoEffect {

    func run(todo: Todo) -> AppEffectTask
}

protocol AsyncTodoEffect {

    func run(todo: Todo) async throws
}

protocol TodoListEffect {

    func run(todoList: [Todo]) -> AppEffectTask
}

protocol SyncEffect {

    func run(_ send: Send<App.Action>) async
}
