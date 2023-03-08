//
//  Rx.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.03.2023.
//

import RxSwift

extension Single<WordListState> {

    func executeInBackgroundAndObserveOnMainThread() -> Single<WordListState> {
        subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
    }
}
