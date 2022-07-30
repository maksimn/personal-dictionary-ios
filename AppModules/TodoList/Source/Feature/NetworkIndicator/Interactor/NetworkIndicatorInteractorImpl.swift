//
//  NetwordIndicatorInteractorImpl.swift
//  SuperList
//
//  Created by Maxim Ivanov on 01.01.2022.
//

import RxSwift

final class NetworkIndicatorInteractorImpl: NetworkIndicatorInteractor {

    weak var presenter: NetworkIndicatorPresenter?

    private let httpRequestCounter: HttpRequestCounter
    private let httpRequestCounterSubscriber: HttpRequestCounterSubscriber
    private let disposeBag = DisposeBag()

    init(httpRequestCounter: HttpRequestCounter,
         httpRequestCounterSubscriber: HttpRequestCounterSubscriber) {
        self.httpRequestCounter = httpRequestCounter
        self.httpRequestCounterSubscriber = httpRequestCounterSubscriber
        self.addNotificationObservers()
    }

    var areRequestsPending: Bool {
        httpRequestCounter.areRequestsPending
    }

    func addNotificationObservers() {
        httpRequestCounterSubscriber.counterIncrement
            .subscribe(onNext: { [weak self] _ in
                self?.presenter?.viewUpdateActivityIndicator()
            }).disposed(by: disposeBag)
        httpRequestCounterSubscriber.counterDecrement
            .subscribe(onNext: { [weak self] _ in
                self?.presenter?.viewUpdateActivityIndicator()
            }).disposed(by: disposeBag)
    }
}
