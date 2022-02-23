//
//  WordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

import CoreModule

/// Параметры списка слов, которые можно задать в клиентском коде.
struct WordListParams {

    /// Запускать ли анимацию при первом появлении данных в таблице.
    let shouldAnimateWhenAppear: Bool
}

/// Внешние зависимости фичи "Список слов".
protocol WordListDependency {

    /// Конфигурация приложения.
    var appConfig: Config { get }

    /// Операции create, update, delete со словами в хранилище личного словаря.
    var cudOperations: WordItemCUDOperations { get }

    /// Логгер
    var logger: Logger { get }
}

/// Реализация билдера фичи "Список слов".
final class WordListBuilderImpl: WordListBuilder {

    private let params: WordListParams
    private let dependency: WordListDependency

    /// Инициализатор.
    /// - Parameters:
    ///  - params: параметры списка слов.
    ///  - dependency: внешние зависимости.
    init(params: WordListParams,
         dependency: WordListDependency) {
        self.params = params
        self.dependency = dependency
    }

    /// Создать MVVM-граф фичи
    /// - Returns:
    ///  - MVVM-граф фичи.
    func build() -> WordListMVVM {
        WordListMVVMImpl(
            cudOperations: dependency.cudOperations,
            translationService: createTranslationService(),
            wordItemStream: WordItemStreamImpl.instance,
            viewParams: createWordListViewParams()
        )
    }

    private func createWordListViewParams() -> WordListViewParams {
        WordListViewParams(
            itemHeight: WordItemCell.height,
            cellClass: WordItemCell.self,
            cellReuseIdentifier: "\(WordItemCell.self)",
            cellCornerRadius: 16,
            delegateParams: WordTableDelegateParams(
                shouldAnimateWhenAppear: params.shouldAnimateWhenAppear,
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
            logger: dependency.logger
        )
    }
}
