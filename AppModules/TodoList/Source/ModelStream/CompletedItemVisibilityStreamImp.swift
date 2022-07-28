//
//  TodoItemStream.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import RxCocoa
import RxSwift

final class CompletedItemVisibilityStreamImp: CompletedItemVisibilityPublisher, CompletedItemVisibilitySubscriber {

    private let publishRelay = PublishRelay<Bool>()

    private init() {}

    static let instance = CompletedItemVisibilityStreamImp()

    func send(isVisible: Bool){
        publishRelay.accept(isVisible)
    }

    var isVisible: Observable<Bool> {
        publishRelay.asObservable()
    }
}
