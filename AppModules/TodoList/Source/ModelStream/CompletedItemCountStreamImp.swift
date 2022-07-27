//
//  TodoItemStream.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import RxCocoa
import RxSwift

final class CompletedItemCountStream: CompletedItemCountPublisher, CompletedItemCountSubscriber {

    private let publishRelay = PublishRelay<Int>()

    private init() {}

    static let instance = CompletedItemCountStream()

    func send(count: Int){
        publishRelay.accept(count)
    }

    var count: Observable<Int> {
        publishRelay.asObservable()
    }
}
