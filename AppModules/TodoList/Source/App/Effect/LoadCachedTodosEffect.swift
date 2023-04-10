//
//  LoadCachedTodosEffect.swift
//  
//
//  Created by Maksim Ivanov on 10.04.2023.
//

struct LoadCachedTodosEffect: Effect {

    let cache: TodoListCache

    func run() -> AppEffectTask {
        .task {
            .cachedTodosLoaded(todos: cache.todos)
        }
    }
}
