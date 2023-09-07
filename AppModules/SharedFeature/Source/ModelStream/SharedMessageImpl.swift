//
//  SharedMessageImpl.swift
//  SharedFeature
//
//  Created by Maxim Ivanov on 31.08.2023.
//

import RxCocoa
import RxSwift

public struct SharedMessageStreamImpl: SharedMessageStream, SharedMessageSender {

    private init() {}

    public static let instance = SharedMessageStreamImpl()

    private let publishRelay = PublishRelay<String>()

    public var sharedMessage: Observable<String> {
        publishRelay.asObservable()
    }

    public func send(sharedMessage: String) {
        publishRelay.accept(sharedMessage)
    }
}
