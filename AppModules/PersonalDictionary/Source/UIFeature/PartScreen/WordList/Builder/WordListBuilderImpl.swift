//
//  WordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import CoreModule

/// Реализация билдера фичи "Список слов".
final class WordListBuilderImpl: WordListBuilder {

    private let shouldAnimateWhenAppear: Bool
    private weak var dependency: RootDependency?

    /// Инициализатор.
    /// - Parameters:
    ///  - shouldAnimateWhenAppear: запускать ли анимацию при первом появлении данных в таблице.
    init(shouldAnimateWhenAppear: Bool,
         dependency: RootDependency) {
        self.shouldAnimateWhenAppear = shouldAnimateWhenAppear
        self.dependency = dependency
    }

    /// Создать граф фичи
    /// - Returns:
    ///  - граф фичи.
    func build() -> WordListGraph {
        guard let dependency = dependency else { return Empty() }
        let viewParams = WordListViewParams(
            itemHeight: WordTableViewCell.height,
            cellClass: WordTableViewCell.self,
            cellReuseIdentifier: "\(WordTableViewCell.self)",
            cellCornerRadius: 16,
            delegateParams: WordTableViewDelegateParams(
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
        )
        let translationService = PonsTranslationService(
            secret: dependency.appConfig.ponsApiSecret,
            httpClient: HttpClientImpl(sessionConfiguration: URLSessionConfiguration.default),
            logger: LoggerImpl(category: "PersonalDictionary.WordList")
        )

        return WordListGraphImpl(
            viewParams: viewParams,
            cudOperations: WordListRepositoryImpl(appConfig: dependency.appConfig, bundle: dependency.bundle),
            translationService: translationService,
            wordStream: WordStreamImpl.instance
        )
    }

    private class Empty: WordListGraph {

        let viewController = UIViewController()

        var model: WordListModel?
    }
}
