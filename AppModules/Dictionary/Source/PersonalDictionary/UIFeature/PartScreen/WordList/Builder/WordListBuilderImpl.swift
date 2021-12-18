//
//  WordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import CoreModule

final class WordListBuilderImpl: WordListBuilder {

    private let dependencies: WordListDependencies

    init(cudOperations: WordItemCUDOperations,
         translationService: TranslationService,
         appViewConfigs: AppViewConfigs,
         logger: Logger) {
        dependencies = WordListDependencies(cudOperations: cudOperations,
                                            translationService: translationService,
                                            appViewConfigs: appViewConfigs,
                                            logger: logger)
    }

    func build() -> WordListMVVM {
        WordListMVVMImpl(cudOperations: dependencies.cudOperations,
                         translationService: dependencies.translationService,
                         wordItemStream: dependencies.wordItemStream,
                         viewParams: dependencies.viewParams,
                         logger: dependencies.logger)
    }
}
