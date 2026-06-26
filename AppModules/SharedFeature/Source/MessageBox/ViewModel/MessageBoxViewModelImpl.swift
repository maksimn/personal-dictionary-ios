//
//  MessageBoxViewModelImpl.swift
//  SharedFeature
//
//  Created by Maxim Ivanov on 31.08.2023.
//

import Foundation
import Observation

@Observable
final class MessageBoxViewModelImpl: MessageBoxViewModel {

    private(set) var state: MessageBoxState = .init(text: "", isHidden: true)

    private let sharedMessageStream: SharedMessageStream
    private let duration: Int

    private var tasks: [Task<Void, Never>] = []

    init(sharedMessageStream: SharedMessageStream, duration: Int) {
        self.sharedMessageStream = sharedMessageStream
        self.duration = duration
        subscribe()
    }

    deinit {
        tasks.forEach { $0.cancel() }
    }

    private func subscribe() {
        tasks.append(
            Task { [weak self] in
                guard let self else { return }

                for await message in sharedMessageStream.sharedMessage {
                    onNext(sharedMessage: message)

                    try? await Task.sleep(nanoseconds: UInt64(duration) * 1_000_000_000)

                    hide()
                }
            }
        )
    }

    private func onNext(sharedMessage: String) {
        guard state.isHidden else { return }

        state = MessageBoxState(text: sharedMessage, isHidden: false)
    }

    private func hide() {
        guard !state.isHidden else { return }

        state = MessageBoxState(text: "", isHidden: true)
    }
}
