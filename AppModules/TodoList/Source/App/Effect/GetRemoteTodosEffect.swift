//
//  GetRemoteTodosEffect.swift
//  
//
//  Created by Maksim Ivanov on 10.04.2023.
//

import CoreModule
import ComposableArchitecture

struct GetRemoteTodosEffect: Effect {

    let cache: TodoListCache
    let service: TodoListService
    let syncEffect: SyncEffect

    func run() -> AppEffectTask {
        .run { send in
            if cache.isDirty {
                await syncEffect.run(send)
                return
            }

            await send(.getRemoteTodosStart)
            await send(.networkIndicator(.incrementNetworkRequestCount))

            do {
                let todos = try await service.getTodos()

                await send(.getRemoteTodosSuccess(todos: todos))
            } catch {
                await send(.getRemoteTodosError(error))
            }

            await send(.networkIndicator(.decrementNetworkRequestCount))
        }
    }
}
