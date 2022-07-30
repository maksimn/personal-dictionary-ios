//
//  TodoItemStream.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import RxCocoa
import RxSwift

protocol HttpRequestCounterPublisher {

    func notifyOnRequestCounterIncrement()

    func notifyOnRequestCounterDecrement()
}

protocol HttpRequestCounterSubscriber {

    var counterIncrement: Observable<Void> { get }

    var counterDecrement: Observable<Void> { get }
}

final class HttpRequestCounterStreamImp: HttpRequestCounterPublisher, HttpRequestCounterSubscriber {

    private let counterIncrementRublishRelay = PublishRelay<Void>()
    private let counterDecrementRublishRelay = PublishRelay<Void>()

    private init() {}

    static let instance = HttpRequestCounterStreamImp()

    func notifyOnRequestCounterIncrement() {
        counterIncrementRublishRelay.accept(Void())
    }

    func notifyOnRequestCounterDecrement() {
        counterDecrementRublishRelay.accept(Void())
    }

    var counterIncrement: Observable<Void> {
        counterIncrementRublishRelay.asObservable()
    }

    var counterDecrement: Observable<Void> {
        counterDecrementRublishRelay.asObservable()
    }
}
