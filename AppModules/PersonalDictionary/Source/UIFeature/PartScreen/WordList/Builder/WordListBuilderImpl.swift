//
//  WordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import CoreModule
import UIKit

/// Implementation of the "Word List" feature builder.
final class WordListBuilderImpl: WordListBuilder {

    private let shouldAnimateWhenAppear: Bool
    private let dependency: AppDependency

    private let featureName = "PersonalDictionary.WordList"

    /// Initializer.
    /// - Parameters:
    ///  - shouldAnimateWhenAppear: whether to run animation when data first appears in the table.
    init(shouldAnimateWhenAppear: Bool, dependency: AppDependency) {
        self.shouldAnimateWhenAppear = shouldAnimateWhenAppear
        self.dependency = dependency
    }

    /// Create the feature graph
    /// - Returns:
    ///  - feature graph.
    func build() -> WordListGraph {
        WordListGraphImpl(
            viewParams: viewParams(),
            updateWordDbWorker: UpdateWordDbWorkerFactory(featureName: featureName).create(),
            deleteWordDbWorker: DeleteWordDbWorkerFactory(featureName: featureName).create(),
            router: router(),
            updatedWordStream: UpdatedWordStreamFactory(featureName: featureName).create(),
            removedWordStream: RemovedWordStreamFactory(featureName: featureName).create(),
            logger: LoggerImpl(category: featureName)
        )
    }

    private func router() -> NavToDictionaryEntryRouter<DictionaryEntryBuilder> {
        let dictionaryEntryBuilder = DictionaryEntryBuilder(
            bundle: dependency.bundle,
            ponsSecret: dependency.appConfig.ponsApiSecret
        )

        return NavToDictionaryEntryRouter(
            navigationController: dependency.navigationController,
            builder: dictionaryEntryBuilder
        )
    }

    private func viewParams() -> WordListViewParams {
        let delegateParams = WordTableViewDelegateParams(
            shouldAnimateWhenAppear: shouldAnimateWhenAppear,
            cellSlideInDuration: 0.5,
            cellSlideInDelayFactor: 0.05,
            deleteActionImage: UIImage(
                systemName: "trash",
                withConfiguration: UIImage.SymbolConfiguration(weight: .bold)
            )!,
            deleteActionBackgroundColor: UIColor(red: 1, green: 0.271, blue: 0.227, alpha: 1),
            favoriteActionImage: UIImage(systemName: "star.fill")!,
            favoriteActionBackgroundColor: UIColor(red: 1.00, green: 0.84, blue: 0.00, alpha: 1.00)
        )

        return WordListViewParams(
            itemHeight: WordTableViewCell.height,
            cellClass: WordTableViewCell.self,
            cellReuseIdentifier: "\(WordTableViewCell.self)",
            cellCornerRadius: 16,
            delegateParams: delegateParams
        )
    }
}
