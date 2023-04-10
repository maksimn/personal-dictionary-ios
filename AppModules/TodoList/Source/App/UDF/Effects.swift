//
//  MainListEffects.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 06.02.2023.
//

import ComposableArchitecture

protocol Effects {

    func loadCachedTodos() -> EffectTask<App.Action>

    func getRemoteTodos() -> EffectTask<App.Action>

    func replaceAllTodosInCache(todos: [Todo]) -> EffectTask<App.Action>

    func create(todo: Todo) -> EffectTask<App.Action>

    func update(todo: Todo) -> EffectTask<App.Action>

    func delete(todo: Todo) -> EffectTask<App.Action>
}
