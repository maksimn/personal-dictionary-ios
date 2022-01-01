//
//  NetwordIndicatorInteractorImpl.swift
//  SuperList
//
//  Created by Maxim Ivanov on 01.01.2022.
//

final class NetworkIndicatorInteractorImpl: NetworkIndicatorInteractor {

    weak var presenter: NetworkIndicatorPresenter?

    private let httpRequestCounter: HttpRequestCounter?

    init(httpRequestCounter: HttpRequestCounter?) {
        self.httpRequestCounter = httpRequestCounter
        self.addNotificationObservers()
    }

    var areRequestsPending: Bool {
        httpRequestCounter?.areRequestsPending ?? false
    }

    func addNotificationObservers() {
        let ncd = NotificationCenter.default

        ncd.addObserver(self, selector: #selector(onHttpRequestCounterIncrement),
                        name: .httpRequestCounterIncrement, object: nil)
        ncd.addObserver(self, selector: #selector(onHttpRequestCounterDecrement),
                        name: .httpRequestCounterDecrement, object: nil)
    }

    @objc func onHttpRequestCounterIncrement(_ notification: Notification) {
        presenter?.viewUpdateActivityIndicator()
    }

    @objc func onHttpRequestCounterDecrement(_ notification: Notification) {
        presenter?.viewUpdateActivityIndicator()
    }
}
