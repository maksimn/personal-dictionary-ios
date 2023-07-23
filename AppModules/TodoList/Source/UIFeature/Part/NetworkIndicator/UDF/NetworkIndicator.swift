//
//  NetworkIndicator.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 17.01.2023.
//

import ComposableArchitecture

struct NetworkIndicator: ReducerProtocol {

    struct State: Equatable {
        var pendingRequestCount = 0

        var isVisible: Bool {
            pendingRequestCount > 0
        }
    }

    enum Action: Equatable {
        case incrementNetworkRequestCount
        case decrementNetworkRequestCount
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .incrementNetworkRequestCount:
            state.pendingRequestCount += 1
        case .decrementNetworkRequestCount:
            state.pendingRequestCount = state.pendingRequestCount > 0 ? state.pendingRequestCount - 1 : 0
        }

        return .none
    }
}
