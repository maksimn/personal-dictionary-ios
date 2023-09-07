//
//  MessageBoxViewModelImpl.swift
//  SharedFeature
//
//  Created by Maxim Ivanov on 31.08.2023.
//

import RxSwift

final class MessageBoxViewModelImpl: MessageBoxViewModel {

    let state: BindableMessageBoxState = .init(value: .init(text: "", isHidden: true))

    private let sharedMessageStream: SharedMessageStream
    private let duration: Int
    private let disposeBag = DisposeBag()

    init(sharedMessageStream: SharedMessageStream, duration: Int) {
        self.sharedMessageStream = sharedMessageStream
        self.duration = duration
        subscribe()
    }

    private func subscribe() {
        sharedMessageStream.sharedMessage
            .do(onNext: { [weak self] in
                self?.onNext(sharedMessage: $0)
            })
            .delay(.seconds(duration), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.hide()
            })
            .disposed(by: disposeBag)
    }

    private func onNext(sharedMessage: String) {
        guard state.value.isHidden else { return }

        state.accept(MessageBoxState(text: sharedMessage, isHidden: false))
    }

    private func hide() {
        guard !state.value.isHidden else { return }

        state.accept(MessageBoxState(text: "", isHidden: true))
    }
}
