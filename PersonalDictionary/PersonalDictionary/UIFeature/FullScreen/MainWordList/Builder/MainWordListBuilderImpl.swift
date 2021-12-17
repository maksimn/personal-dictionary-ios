//
//  MainWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import CoreModule

final class MainWordListBuilderImpl: MainWordListBuilder {

    private let dependencies: MainWordListDependencies

    init(appConfigs: AppConfigs,
         coreRouter: CoreRouter?,
         routingButtonTitle: String) {
        dependencies = MainWordListDependencies(appConfigs: appConfigs,
                                                coreRouter: coreRouter,
                                                routingButtonTitle: routingButtonTitle)
    }

    func build() -> MainWordListGraph {
        MainWordListGraphImpl(viewParams: dependencies.viewParams,
                              wordListBuilder: dependencies.createWordListBuilder(),
                              wordListFetcher: dependencies.buildWordListRepository(),
                              newWordBuilder: dependencies.createNewWordBuilder(),
                              searchBuilder: dependencies.createSearchBuilder(),
                              coreRouter: dependencies.coreRouter)
    }
}
