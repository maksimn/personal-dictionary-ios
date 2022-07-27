//
//  TodoItemStream.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import RxCocoa
import RxSwift

final class CompletedItemCountStreamImp: CompletedItemCountStream {

    private let publishRelay = PublishRelay<Int>()

    private init() {}

    static let instance = CompletedItemCountStreamImp()

    func send(count: Int){
        publishRelay.accept(count)
    }

    var count: Observable<Int> {
        publishRelay.asObservable()
    }
}
