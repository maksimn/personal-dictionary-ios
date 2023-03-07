//
//  Rx.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.03.2023.
//

import RxSwift

extension Observable<Word> {

    func executeInBackgroundAndObserveOnMainThread() -> Observable<Word> {
        subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
    }
}

extension Single<Word> {

    func executeInBackgroundAndObserveOnMainThread() -> Single<Word> {
        subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
            .observeOn(MainScheduler.instance)
    }
}
