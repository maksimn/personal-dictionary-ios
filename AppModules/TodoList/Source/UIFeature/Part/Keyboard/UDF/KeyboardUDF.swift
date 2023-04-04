//
//  KeyboardUDF.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 15.02.2023.
//

import ComposableArchitecture
import UIKit

struct KeyboardUDF: ReducerProtocol {

    struct State: Equatable {
        var isVisible: Bool {
            size != .zero
        }
        var size = CGSize.zero
        var orientation = Orientation.portrait
    }

    enum Action {
        case show(CGSize)
        case hide
        case changeOrientation(Orientation)
    }

    enum Orientation { case portrait, landscape }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .show(let size):
            state.size = size

        case .hide:
            state.size = .zero

        case .changeOrientation(let orientation):
            state.orientation = orientation
        }

        return .none
    }
}
