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

private let fetchTranslationRequestName = "PONS FETCH TRANSLATION"

/// Служба для получения перевода слова из PONS Online Dictionary API,
final class PonsTranslationService: TranslationService {

    private let httpClient: HttpClient
    private let jsonCoder: JsonCoder
    private let apiData: PonsApiData
    private let logger: Logger

    /// Инициализатор.
    /// - Parameters:
    ///  - apiData: данные для обращения к онлайновому PONS API.
    ///  - httpClient: базовая служба для сетевых запросов по протоколу HTTP.
    ///  - jsonCoder: парсер данных в виде JSON.
    ///  - logger: логгер.
    init(apiData: PonsApiData, httpClient: HttpClient, jsonCoder: JsonCoder, logger: Logger) {
        self.apiData = apiData
        self.httpClient = httpClient
        self.jsonCoder = jsonCoder
        self.logger = logger
    }

    /// Извлечь перевод слова.
    /// - Parameters:
    ///  - word: данные о слове для его перевода.
    /// - Returns:
    ///  - Rx Single, в который завернута строка с переводом заданного слова.
    func fetchTranslation(for word: Word) -> Single<String> {
        let shortSourceLang = word.sourceLang.shortName.lowercased()
        let qParam = "q=\(word.text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        let lParam = "l=\(shortSourceLang)\(word.targetLang.shortName.lowercased())"

        logger.log(message: "\(fetchTranslationRequestName) NETWORK REQUEST START")
        return httpClient
            .send(
                Http(
                    urlString: apiData.url + "?" + lParam + "&" + qParam,
                    method: "GET",
                    headers: [apiData.secretHeaderKey: apiData.secret],
                    body: nil
                )
            )
            .map { [weak self] data -> Single<[PonsResponseData]> in
                self?.jsonCoder.parseFromJson(data) ?? Single.just([])
            }
            .asObservable().concat().asSingle()
            .map { [weak self] ponsResponseArray in
                self?.logger.log(message: "\(fetchTranslationRequestName) NETWORK REQUEST SUCCESS")

                return ponsResponseArray.first?.translation ?? ""
            }
    }
}
