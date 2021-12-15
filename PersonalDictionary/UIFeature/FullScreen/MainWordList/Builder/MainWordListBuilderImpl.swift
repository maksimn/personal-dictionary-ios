//
//  MainWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

final class MainWordListBuilderImpl: MainWordListBuilder {

    private let dependencies: MainWordListDependencies

    init(appConfigs: AppConfigs) {
        dependencies = MainWordListDependencies(appConfigs: appConfigs)
    }

    func build() -> MainWordListGraph {
        MainWordListGraphImpl(viewParams: dependencies.viewParams,
                              wordListBuilder: dependencies.createWordListBuilder(),
                              wordListFetcher: dependencies.buildWordListRepository(),
                              newWordBuilder: dependencies.createNewWordBuilder(),
                              searchBuilder: dependencies.createSearchBuilder())
    }
}
