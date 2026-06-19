//
//  MainWordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import CoreModule
import UIKit

/// Implementation of the "Main Word List" feature builder of the Personal Dictionary.
final class MainWordListBuilder: ViewControllerBuilder {

    private let dependency: AppDependency

    init(dependency: AppDependency) {
        self.dependency = dependency
    }

    /// Create the screen.
    /// - Returns:
    ///  - "Main Word List" screen.
    func build() -> UIViewController {
        let featureName = "PersonalDictionary.MainWordList"
        let dictionaryServiceFactory = DictionaryServiceFactory(
            secret: dependency.appConfig.ponsApiSecret,
            featureName: featureName,
            bundle: dependency.bundle,
            isErrorSendable: true
        )

        let model = MainWordListModelImpl(
            wordListFetcher: WordListFetcherFactory(featureName: featureName).create(),
            сreateWordDbWorker: CreateWordDbWorkerFactory(featureName: featureName).create(),
            dictionaryService: dictionaryServiceFactory.create()
        )
        let viewModel = MainWordListViewModelImpl(
            model: model,
            newWordStream: NewWordStreamFactory(featureName: featureName).create(),
            logger: LoggerImpl(category: featureName)
        )
        let view = MainWordListViewController(
            viewModel: viewModel,
            wordListBuilder: WordListBuilderImpl(shouldAnimateWhenAppear: true, dependency: dependency)
        )

        return view
    }
}
