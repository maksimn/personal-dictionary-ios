//
//  NetwordIndicatorVIPERImpl.swift
//  SuperList
//
//  Created by Maxim Ivanov on 01.01.2022.
//

final class NetworkIndicatorVIPERImpl: NetworkIndicatorVIPER {

    private let view: NetworkIndicatorViewImpl

    init(httpRequestCounter: HttpRequestCounter) {
        view = NetworkIndicatorViewImpl()

        let interactor = NetworkIndicatorInteractorImpl(
            httpRequestCounter: httpRequestCounter,
            httpRequestCounterSubscriber: HttpRequestCounterStreamImp.instance
        )
        let presenter = NetworkIndicatorPresenterImpl(view: view, interactor: interactor)

        view.presenter = presenter
        interactor.presenter = presenter

        presenter.viewUpdateActivityIndicator()
    }

    var uiview: UIView {
        view
    }
}
