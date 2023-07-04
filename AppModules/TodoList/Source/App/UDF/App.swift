//
//  App.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 01.02.2023.
//

import ComposableArchitecture
import Foundation

struct App: ReducerProtocol {

    let cache: TodoListCache
    let deadCache: DeadCache
    let service: TodoListService
    let currentDate: () -> Date

    struct State: Equatable {
        var mainList = MainList.State()
        var networkIndicator = NetworkIndicator.State()
    }

    enum Action {
        case cachedTodosLoaded(todos: [Todo])

        case getRemoteTodosResult(TaskResult<[Todo]>)

        case replaceAllTodosInCache([Todo])
        case replaceAllTodosInCacheResult(TaskResult<[Todo]>)

        case syncWithRemoteTodos
        case syncWithRemoteTodosResult(TaskResult<[Todo]>)

        case create(Todo)
        case createRemote(Todo)
        case createRemoteResult(TaskResult<Todo>)

        case update(Todo)
        case updateRemote(Todo)
        case updateRemoteResult(TaskResult<Todo>)

        case delete(Todo)
        case deleteRemote(Todo)
        case deleteRemoteResult(TaskResult<Todo>)

        case mainList(MainList.Action)
        case networkIndicator(NetworkIndicator.Action)
    }

    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            reduceInto(&state, action: action)
        }
        Scope(state: \.mainList, action: /Action.mainList) {
            MainList()
        }
        Scope(state: \.networkIndicator, action: /Action.networkIndicator) {
            NetworkIndicator()
        }
    }

    private func reduceInto(_ state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .cachedTodosLoaded(let todos):
            update(state: &state, with: todos)

        case .getRemoteTodosResult(.success(let todos)),
             .syncWithRemoteTodosResult(.success(let todos)):
            update(state: &state, with: todos)

            return .run { send in
                await send(.networkIndicator(.decrementNetworkRequestCount))
                await send(.replaceAllTodosInCache(todos))
            }

        case .replaceAllTodosInCache(let todos):
            return .run { send in
                await send(
                    .replaceAllTodosInCacheResult(
                        TaskResult {
                            try await cache.replaceWith(todos)
                            return todos
                        }
                    )
                )
            }

        case .create(let todo):
            let dirtyTodo = todo.update(isDirty: true)
            let cleanTodo = todo.update(isDirty: false)

            if cache.isDirty {
                return .run { send in
                    try await cache.insert(dirtyTodo)
                    await send(.syncWithRemoteTodos)
                }
            }

            return .run { send in
                try await cache.insert(dirtyTodo)
                await send(.createRemote(cleanTodo))
            }

        case .createRemote(let todo):
            return .run { send in
                await send(.networkIndicator(.incrementNetworkRequestCount))
                await send(.createRemoteResult(
                    TaskResult {
                        try await service.createRemote(todo)
                        return todo
                    }
                ))
            }

        case .createRemoteResult(.success(let todo)),
             .updateRemoteResult(.success(let todo)):
            return .run { send in
                await send(.networkIndicator(.decrementNetworkRequestCount))
                try await cache.update(todo.update(isDirty: false))
            }

        case .getRemoteTodosResult(.failure),
             .createRemoteResult(.failure),
             .updateRemoteResult(.failure),
             .deleteRemoteResult:
            return .send(.networkIndicator(.decrementNetworkRequestCount))

        case .update(let todo):
            let dirtyTodo = todo.update(isDirty: true)

            if cache.isDirty {
                return .run { send in
                    try await cache.update(dirtyTodo)
                    await send(.syncWithRemoteTodos)
                }
            }

            return .run { send in
                try await cache.update(dirtyTodo)
                await send(.updateRemote(dirtyTodo))
            }

        case .updateRemote(let todo):
            return .run { send in
                await send(.networkIndicator(.incrementNetworkRequestCount))
                await send(.updateRemoteResult(
                    TaskResult {
                        try await service.updateRemote(todo)
                        return todo
                    }
                ))
            }

        case .delete(let todo):
            return .run { send in
                try await cache.delete(todo)
                await send(.deleteRemote(todo))
            }

        case .deleteRemote(let todo):
            if cache.isDirty {
                return .run { send in
                    try await deadCache.insert(Tombstone(todoId: todo.id, deletedAt: currentDate()))
                    await send(.syncWithRemoteTodos)
                }
            }

            return .run { send in
                await send(.networkIndicator(.incrementNetworkRequestCount))
                await send(.deleteRemoteResult(
                    TaskResult {
                        try await service.deleteRemote(todo)
                        return todo
                    }
                ))
            }

        case .syncWithRemoteTodos:
            let deleted = Array(Set(deadCache.items.map { $0.todoId }))
            let dirtyTodos = cache.todos.filter { $0.isDirty }

            return .run { send in
                await send(.networkIndicator(.incrementNetworkRequestCount))

                do {
                    let todos = try await service.syncWithRemote(deleted, dirtyTodos)

                    try await deadCache.clear()
                    await send(.syncWithRemoteTodosResult(.success(todos)))
                } catch {
                    await send(.syncWithRemoteTodosResult(.failure(error)))
                }

                await send(.networkIndicator(.decrementNetworkRequestCount))
            }

        case .mainList(let action):
            return reduceInto(&state, mainListAction: action)

        default:
            return .none
        }

        return .none
    }

    private func reduceInto(_ state: inout State, mainListAction action: MainList.Action) -> EffectTask<Action> {
        switch action {
        case .loadCachedTodos:
            return .send(.cachedTodosLoaded(todos: cache.todos))

        case .getRemoteTodos:
            if cache.isDirty {
                return .send(.syncWithRemoteTodos)
            }

            return .run { send in
                await send(.networkIndicator(.incrementNetworkRequestCount))
                await send(.getRemoteTodosResult(TaskResult { try await service.getTodos() }))
            }

        case .createTodo(let todo):
            return .send(.create(todo))

        case .toggleTodoCompletion(let todo):
            return .send(.update(todo.update(isCompleted: !todo.isCompleted)))

        case .deleteTodo(let todo):
            return .send(.delete(todo))

        case .editor(.saveTodo(let todo, let mode)):
            switch mode {
            case .create:
                return .send(.create(todo))

            case .edit:
                return .send(.update(todo))
            }

        case .editor(.deleteTodo(let todo)):
            return .send(.delete(todo))

        default:
            return .none
        }
    }

    private func update(state: inout State, with todos: [Todo]) {
        state.mainList.todos = todos
        state.mainList.completedTodoCount = todos.filter({ $0.isCompleted }).count
    }
}
