//
//  SearchWordListBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.11.2022.
//

import CoreModule

final class MainSwitchBuilder: ViewControllerBuilder {

    private let dependency: RootDependency

    init(dependency: RootDependency) {
        self.dependency = dependency
    }

    func build() -> UIViewController {
        let initialState = MainScreenState.main
        let model = MainSwitchModel(
            initialState: initialState,
            mainScreenStateStream: MainScreenStateStreamImpl.instance,
            logger: SLoggerImp(category: "PersonalDictionary.MainSwitch")
        )
        let presenter = MainSwitchPresenterImpl(model: model)
        let view = MainSwitchViewController(
            initialState: initialState,
            presenter: presenter,
            mainWordListBuilder: MainWordListBuilder(dependency: dependency),
            searchBuilder: SearchBuilder(dependency: dependency)
        )

        presenter.view = view
        model.presenter = presenter

        return view
    }
}
