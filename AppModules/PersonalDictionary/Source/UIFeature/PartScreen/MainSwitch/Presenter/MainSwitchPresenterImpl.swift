//
//  WordListViewModelImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

final class MainSwitchPresenterImpl: MainSwitchPresenter {

    weak var view: MainSwitchView?
    private let model: Model

    init(model: Model) {
        self.model = model
    }

    func update(_ state: MainScreenState) {
        view?.update(state)
    }
}
