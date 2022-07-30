//
//  NetwordIndicatorBuilderImpl.swift
//  SuperList
//
//  Created by Maxim Ivanov on 01.01.2022.
//

final class NetworkIndicatorBuilderImpl: NetworkIndicatorBuilder {

    func build() -> UIView {
        let view = NetworkIndicatorViewImpl()

        let interactor = NetworkIndicatorInteractorImpl(
            httpRequestCounter: HttpRequestCounterOne(
                httpRequestCounterPublisher: HttpRequestCounterStreamImp.instance
            ),
            httpRequestCounterSubscriber: HttpRequestCounterStreamImp.instance
        )
        let presenter = NetworkIndicatorPresenterImpl(view: view, interactor: interactor)

        view.presenter = presenter
        interactor.presenter = presenter

        presenter.viewUpdateActivityIndicator()

        return view
    }
}
