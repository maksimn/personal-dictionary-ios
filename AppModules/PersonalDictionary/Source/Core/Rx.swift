//
//  Rx.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.03.2023.
//

import RxSwift

extension Single<WordListState> {

    func executeInBackgroundAndObserveOnMainThread() -> Single<WordListState> {
        subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .observe(on: MainScheduler.instance)
    }
}
