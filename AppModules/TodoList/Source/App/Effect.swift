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

protocol TodoListEffect {

    func run(todoList: [Todo]) -> AppEffectTask
}

protocol SyncEffect {

    func run(_ send: Send<App.Action>) async
}

protocol CachedTodoEffect {

    func run(todo: Todo, shouldSync: Bool, _ send: Send<App.Action>) async throws
}
