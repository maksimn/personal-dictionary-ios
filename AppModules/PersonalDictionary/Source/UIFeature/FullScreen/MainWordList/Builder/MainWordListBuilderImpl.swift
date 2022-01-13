//
//  MainWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import CoreModule

final class MainWordListBuilderImpl: MainWordListBuilder {

    private let appConfigs: AppConfigs

    init(appConfigs: AppConfigs) {
        self.appConfigs = appConfigs
    }

    func build() -> MainWordListGraph {
        let dependencies = MainWordListDependencies(appConfigs: appConfigs)

        return MainWordListGraphImpl(viewParams: dependencies.viewParams,
                                     wordListBuilder: dependencies.createWordListBuilder(),
                                     wordListFetcher: dependencies.buildWordListRepository(),
                                     newWordBuilder: dependencies.createNewWordBuilder(),
                                     searchBuilder: dependencies.createSearchBuilder(),
                                     coreRouter: appConfigs.appParams.coreRouter)
    }
}
