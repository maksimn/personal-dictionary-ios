//
//  WordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import CoreModule

final class WordListBuilderImpl: WordListBuilder {

    private let appConfigs: AppConfigs
    private let cudOperations: WordItemCUDOperations

    init(appConfigs: AppConfigs,
         cudOperations: WordItemCUDOperations) {
        self.appConfigs = appConfigs
        self.cudOperations = cudOperations
    }

    func build() -> WordListMVVM {
        let dependencies = WordListDependencies(appConfigs: appConfigs)

        return WordListMVVMImpl(cudOperations: cudOperations,
                                translationService: dependencies.translationService,
                                wordItemStream: dependencies.wordItemStream,
                                viewParams: dependencies.viewParams,
                                logger: dependencies.logger)
    }
}
