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
    private let dependency: RootDependency

    /// Инициализатор.
    /// - Parameters:
    ///  - shouldAnimateWhenAppear: запускать ли анимацию при первом появлении данных в таблице.
    init(shouldAnimateWhenAppear: Bool,
         dependency: RootDependency) {
        self.shouldAnimateWhenAppear = shouldAnimateWhenAppear
        self.dependency = dependency
    }

    /// Создать MVVM-граф фичи
    /// - Returns:
    ///  - MVVM-граф фичи.
    func build() -> WordListMVVM {
        WordListMVVMImpl(
            viewParams: createWordListViewParams(),
            cudOperations: CoreWordListRepository(appConfig: dependency.appConfig, bundle: dependency.bundle),
            translationService: createTranslationService(),
            wordItemStream: WordItemStreamImpl.instance
        )
    }

    private func createWordListViewParams() -> WordListViewParams {
        WordListViewParams(
            itemHeight: WordItemCell.height,
            cellClass: WordItemCell.self,
            cellReuseIdentifier: "\(WordItemCell.self)",
            cellCornerRadius: 16,
            delegateParams: WordTableDelegateParams(
                shouldAnimateWhenAppear: shouldAnimateWhenAppear,
                cellSlideInDuration: 0.5,
                cellSlideInDelayFactor: 0.05,
                deleteActionImage: UIImage(systemName: "trash",
                                           withConfiguration: UIImage.SymbolConfiguration(weight: .bold))!,
                deleteActionBackgroundColor: UIColor(red: 1, green: 0.271, blue: 0.227, alpha: 1),
                favoriteActionImage: UIImage(systemName: "star.fill")!,
                favoriteActionBackgroundColor: UIColor(red: 1.00, green: 0.84, blue: 0.00, alpha: 1.00)
            )
        )
    }

    private func createTranslationService() -> TranslationService {
        PonsTranslationService(
            apiData: PonsApiData(url: "https://api.pons.com/v1/dictionary",
                                 secretHeaderKey: "X-Secret",
                                 secret: dependency.appConfig.ponsApiSecret),
            httpClient: HttpClientImpl(sessionConfiguration: URLSessionConfiguration.default),
            jsonCoder: JSONCoderImpl(),
            logger: LoggerImpl(isLoggingEnabled: dependency.appConfig.isLoggingEnabled)
        )
    }
}
