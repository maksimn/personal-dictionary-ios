//
//  VisibilitySwitchBuilder.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 13.08.2022.
//

import ComposableArchitecture
import UIKit

typealias ShowButtonStore = Store<ShowButton.State, ShowButton.Action>
typealias ShowButtonViewStore = ViewStore<ShowButton.State, ShowButton.Action>

final class ShowButtonBuilder: ViewBuilder {

    private let store: ShowButtonStore

    init(store: ShowButtonStore) {
        self.store = store
    }

    func build() -> UIView {
        let showText = NSLocalizedString("LS_SHOW", comment: "")
        let hideText = NSLocalizedString("LS_HIDE", comment: "")

        let view = ShowButtonView(
            params: ShowButtonParams(
                show: showText,
                hide: hideText
            ),
            store: store
        )

        return view
    }
}
