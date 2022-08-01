//
//  TodoItemStream.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import RxCocoa
import RxSwift

protocol HttpRequestCounterPublisher {

    func increment()

    func decrement()
}

protocol HttpRequestCounterSubscriber {

    var count: Observable<Int> { get }
}

final class HttpRequestCounterStreamImp: HttpRequestCounterPublisher, HttpRequestCounterSubscriber {

    private let behaviorRelay = BehaviorRelay<Int>(value: 0)

    private init() {}

    static let instance = HttpRequestCounterStreamImp()

    func increment() {
        behaviorRelay.accept(behaviorRelay.value + 1)
    }

    func decrement() {
        if behaviorRelay.value > 0 {
            behaviorRelay.accept(behaviorRelay.value - 1)
        }
    }

    var count: Observable<Int> {
        behaviorRelay.asObservable()
    }
}
