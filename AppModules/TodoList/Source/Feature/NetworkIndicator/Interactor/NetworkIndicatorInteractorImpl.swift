//
//  NetwordIndicatorInteractorImpl.swift
//  SuperList
//
//  Created by Maxim Ivanov on 01.01.2022.
//

import RxSwift

final class NetworkIndicatorInteractorImpl: NetworkIndicatorInteractor {

    weak var presenter: NetworkIndicatorPresenter?

    private let httpRequestCounterSubscriber: HttpRequestCounterSubscriber
    private let disposeBag = DisposeBag()

    init(httpRequestCounterSubscriber: HttpRequestCounterSubscriber) {
        self.httpRequestCounterSubscriber = httpRequestCounterSubscriber
    }

    func subscribe() {
        httpRequestCounterSubscriber.count
            .subscribe(onNext: { [weak self] count in
                self?.presenter?.updateActivityIndicator(visible: count > 0)
            }).disposed(by: disposeBag)
    }
}
