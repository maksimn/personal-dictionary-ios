//
//  NetwordIndicatorPresenterImpl.swift
//  SuperList
//
//  Created by Maxim Ivanov on 01.01.2022.
//

final class NetworkIndicatorPresenterImpl: NetworkIndicatorPresenter {

    private weak var view: NetworkIndicatorView?
    private let interactor: NetworkIndicatorInteractor

    init(view: NetworkIndicatorView?,
         interactor: NetworkIndicatorInteractor) {
        self.view = view
        self.interactor = interactor
    }

    func viewUpdateActivityIndicator() {
        view?.set(visible: interactor.areRequestsPending)
    }
}
