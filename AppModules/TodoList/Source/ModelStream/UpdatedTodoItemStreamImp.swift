//
//  UpdatedTodoItemStreamImp.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import RxCocoa
import RxSwift

final class UpdatedTodoItemStreamImp: UpdatedTodoItemStream {

    private let publishRelay = PublishRelay<UpdatedTodoItemData>()

    private init() {}

    static let instance = UpdatedTodoItemStreamImp()

    func send(_ data: UpdatedTodoItemData) {
        publishRelay.accept(data)
    }

    var updatedTodoItemData: Observable<UpdatedTodoItemData> {
        publishRelay.asObservable()
    }
}
