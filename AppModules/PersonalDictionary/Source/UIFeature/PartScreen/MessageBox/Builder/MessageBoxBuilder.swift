//
//  MessageBoxBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 31.08.2023.
//

import CoreModule
import UIKit

struct MessageBoxBuilder: ViewBuilder {

    func build() -> UIView {
        let duration = 4

        let viewModel = MessageBoxViewModelImpl(
            sharedMessageStream: SharedMessageStreamImpl.instance,
            duration: duration
        )
        let view = MessageBoxView(viewModel: viewModel, duration: duration)

        return view
    }
}
