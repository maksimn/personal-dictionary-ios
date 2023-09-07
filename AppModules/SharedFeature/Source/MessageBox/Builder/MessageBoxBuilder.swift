//
//  MessageBoxBuilder.swift
//  SharedFeature
//
//  Created by Maxim Ivanov on 31.08.2023.
//

import CoreModule
import UIKit

public struct MessageBoxBuilder: ViewBuilder {

    public init() {}

    public func build() -> UIView {
        let duration = 4

        let viewModel = MessageBoxViewModelImpl(
            sharedMessageStream: SharedMessageStreamImpl.instance,
            duration: duration
        )
        let view = MessageBoxView(viewModel: viewModel, duration: duration)

        return view
    }
}
