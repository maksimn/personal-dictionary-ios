//
//  PonsTranslationService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import CoreModule
import RxSwift

/// Данные для обращения к онлайновому PONS API.
struct PonsApiData {

    /// Строковый URL для запроса
    let url: String

    /// Название HTTP-заголовка для передачи секретного ключа
    let secretHeaderKey: String

    /// Ключ для запроса
    let secret: String
}

/// Служба для получения перевода слова из PONS Online Dictionary API,
final class PonsTranslationService: TranslationService {

    private let coreService: CoreService
    private let jsonCoder: JsonCoder
    private let apiData: PonsApiData
    private let logger: Logger

    private let fetchTranslationRequestName = "PONS FETCH TRANSLATION"

    /// Инициализатор.
    /// - Parameters:
    ///  - apiData: данные для обращения к онлайновому PONS API.
    ///  - coreService: базовая служба для сетевых запросов по протоколу HTTP.
    ///  - jsonCoder: парсер данных в виде JSON.
    ///  - logger: логгер.
    init(apiData: PonsApiData, coreService: CoreService, jsonCoder: JsonCoder, logger: Logger) {
        self.apiData = apiData
        self.coreService = coreService
        self.jsonCoder = jsonCoder
        self.logger = logger
    }

    /// Извлечь перевод слова.
    /// - Parameters:
    ///  - wordItem: данные о слове для его перевода.
    /// - Returns:
    ///  - Rx Single, в который завернута строка с переводом заданного слова.
    func fetchTranslation(for wordItem: WordItem) -> Single<String> {
        let shortSourceLang = wordItem.sourceLang.shortName.lowercased()
        let qParam = "q=\(wordItem.text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        let lParam = "l=\(shortSourceLang)\(wordItem.targetLang.shortName.lowercased())"

        logger.networkRequestStart(fetchTranslationRequestName)
        return coreService
            .send(Http(urlString: apiData.url + "?" + lParam + "&" + qParam,
                       method: "GET",
                       headers: [apiData.secretHeaderKey: apiData.secret],
                       body: nil))
            .map { [weak self] data -> Single<[PonsResponseData]> in
                self?.jsonCoder.parseFromJson(data) ?? Single.just([])
            }
            .asObservable().concat().asSingle()
            .map { [weak self] ponsResponseArray in
                guard let self = self else { return "" }
                self.logger.networkRequestSuccess(self.fetchTranslationRequestName)
                return ponsResponseArray.first?.translation ?? ""
            }
    }
}
