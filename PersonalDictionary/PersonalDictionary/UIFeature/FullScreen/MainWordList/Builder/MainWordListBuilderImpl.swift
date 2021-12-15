//
//  MainWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

final class MainWordListBuilderImpl: MainWordListBuilder {

    private let dependencies: MainWordListDependencies

    init(appConfigs: AppConfigs,
         superAppRouter: SuperAppRouter?,
         superAppRoutingButtonTitle: String) {
        dependencies = MainWordListDependencies(appConfigs: appConfigs,
                                                superAppRouter: superAppRouter,
                                                superAppRoutingButtonTitle: superAppRoutingButtonTitle)
    }

    func build() -> MainWordListGraph {
        MainWordListGraphImpl(viewParams: dependencies.viewParams,
                              wordListBuilder: dependencies.createWordListBuilder(),
                              wordListFetcher: dependencies.buildWordListRepository(),
                              newWordBuilder: dependencies.createNewWordBuilder(),
                              searchBuilder: dependencies.createSearchBuilder(),
                              superAppRouter: dependencies.superAppRouter)
    }
}
