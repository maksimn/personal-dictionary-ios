//
//  Sync.swift
//  TodoList
//
//  Created by Maksim Ivanov on 10.07.2023.
//

import ComposableArchitecture

struct SyncParams {
    let minDelay: Double
    let maxDelay: Double
    let factor: Double
    let jitter: Double
}

struct Sync: ReducerProtocol {

    let params: SyncParams
    let dirtyStateCache: DirtyStateCache
    let syncService: SyncService
    let randomNumber: () -> Double

    struct State: Equatable {
        var delay: Double
    }

    enum Action {
        case syncWithRemoteTodos
        case syncWithRemoteTodosResult(TaskResult<[Todo]>)
        case nextDelay
        case setDelayToMinValue
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .syncWithRemoteTodos:
            let delay = state.delay

            return .run { send in
                do {
                    let dirtyData = try dirtyStateCache.dirtyData
                    let todos = try await syncService.syncWithRemoteTodos(dirtyData)
                    let dirtyDataAfter = try dirtyStateCache.dirtyData

                    if dirtyDataAfter != dirtyData {
                        throw SyncError.dirtyStateChangedDuringRequest
                    }

                    await send(.syncWithRemoteTodosResult(.success(todos)))
                    await send(.setDelayToMinValue)
                } catch {
                    try? await Task.sleep(nanoseconds: UInt64(delay) * 1_000_000_000)
                    await send(.syncWithRemoteTodosResult(.failure(error)))
                    await send(.nextDelay)
                    await send(.syncWithRemoteTodos)
                }
            }

        case .nextDelay:
            let delay = min(params.factor * state.delay, params.maxDelay)

            state.delay = delay * (1.0 + params.jitter * randomNumber())

            return .none

        case .setDelayToMinValue:
            state.delay = params.minDelay
            return .none

        default:
            return .none
        }
    }
}

enum SyncError: Error {
    case dirtyStateChangedDuringRequest
}
