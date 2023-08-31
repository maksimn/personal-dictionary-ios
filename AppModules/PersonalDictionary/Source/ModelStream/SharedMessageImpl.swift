//
//  SharedMessageImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 31.08.2023.
//

import RxCocoa
import RxSwift

struct SharedMessageStreamImpl: SharedMessageStream, SharedMessageSender {

    private init() {}

    static let instance = SharedMessageStreamImpl()

    private let publishRelay = PublishRelay<String>()

    var sharedMessage: Observable<String> {
        publishRelay.asObservable()
    }

    func send(sharedMessage: String) {
        publishRelay.accept(sharedMessage)
    }
}
