//
//  EffectHolderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 25.11.2023.
//

import RxSwift

final class EffectHolderImpl: EffectHolder {

    private let effect: Effect
    private let newWordStream: NewWordStream
    private let updatedWordStream: UpdatedWordStream
    private let removedWordStream: RemovedWordStream

    private let disposeBag = DisposeBag()

    init(
        effect: Effect,
        newWordStream: NewWordStream,
        updatedWordStream: UpdatedWordStream,
        removedWordStream: RemovedWordStream
    ) {
        self.effect = effect
        self.newWordStream = newWordStream
        self.updatedWordStream = updatedWordStream
        self.removedWordStream = removedWordStream
        subscribe()
    }

    private func subscribe() {
        newWordStream.newWord.subscribe(onNext: { [weak self] word in
            self?.effect.runCreateWordEffect(word)
        }).disposed(by: disposeBag)
        updatedWordStream.updatedWord.subscribe(onNext: { [weak self] word in
            self?.effect.runUpdateWordEffect(word)
        }).disposed(by: disposeBag)
        removedWordStream.removedWord.subscribe(onNext: { [weak self] word in
            self?.effect.runRemoveWordEffect(word)
        }).disposed(by: disposeBag)
    }
}
