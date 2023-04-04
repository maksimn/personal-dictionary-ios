//
//  NetwordIndicatorBuilderImpl.swift
//  SuperList
//
//  Created by Maxim Ivanov on 01.01.2022.
//

import UIKit

final class NetworkIndicatorBuilderImpl: NetworkIndicatorBuilder {

    func build() -> UIView {
        let view = NetworkIndicatorViewImpl()

        let interactor = NetworkIndicatorInteractorImpl(
            httpRequestCounterSubscriber: HttpRequestCounterStreamImp.instance
        )
        let presenter = NetworkIndicatorPresenterImpl(view: view, interactor: interactor)

        view.presenter = presenter
        interactor.presenter = presenter

        interactor.subscribe()

        return view
    }
}
