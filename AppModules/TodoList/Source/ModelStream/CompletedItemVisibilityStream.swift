//
//  TodoItemStream.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import RxSwift

protocol CompletedItemVisibilityPublisher {

    func send(isVisible: Bool)
}

protocol CompletedItemVisibilitySubscriber {

    var isVisible: Observable<Bool> { get }
}
