//
//  TodoItemStream.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import RxSwift

protocol CompletedItemCountPublisher {

    func send(count: Int)
}

protocol CompletedItemCountSubscriber {

    var count: Observable<Int> { get }
}
