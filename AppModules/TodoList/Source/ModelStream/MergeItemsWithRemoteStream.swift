//
//  MergeItemsWithRemoteStream.swift
//  TodoList
//
//  Created by Maksim Ivanov on 27.07.2022.
//

import RxCocoa
import RxSwift

protocol MergeItemsWithRemotePublisher {

    func notify()
}

protocol MergeItemsWithRemoteSubscriber {

    var mergeSuccess: Observable<Void> { get }
}

final class MergeItemsWithRemoteStreamImp: MergeItemsWithRemotePublisher, MergeItemsWithRemoteSubscriber {

    private let publishRelay = PublishRelay<Void>()

    private init() {}

    static let instance = MergeItemsWithRemoteStreamImp()

    func notify() {
        publishRelay.accept(Void())
    }

    var mergeSuccess: Observable<Void> {
        publishRelay.asObservable()
    }
}
