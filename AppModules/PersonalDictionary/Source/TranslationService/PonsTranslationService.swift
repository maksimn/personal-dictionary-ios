//
//  PonsTranslationService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import CoreModule
import RxSwift

/// Служба для получения перевода слова из PONS Online Dictionary API,
final class PonsTranslationService: TranslationService {

    private let httpClient: HttpClient
    private let secret: String
    private let logger: SLogger

    private let apiUrl = "https://api.pons.com/v1/dictionary"

    /// Инициализатор.
    /// - Parameters:
    ///  - secret: секрет для обращения к онлайновому PONS API.
    ///  - httpClient: базовая служба для сетевых запросов по протоколу HTTP.
    ///  - logger: логгер.
    init(secret: String, httpClient: HttpClient, logger: SLogger) {
        self.secret = secret
        self.httpClient = httpClient
        self.logger = logger
    }

    /// Извлечь перевод слова.
    /// - Parameters:
    ///  - word: данные о слове для его перевода.
    /// - Returns:
    ///  - Rx Single, в который завернута строка с переводом заданного слова.
    func fetchTranslation(for word: Word) -> Single<String> {
        let sourceLang = word.sourceLang.shortName.lowercased()
        let targetLang = word.targetLang.shortName.lowercased()
        var query = URLComponents()

        query.queryItems = [
            URLQueryItem(name: "q", value: word.text),
            URLQueryItem(name: "l", value: sourceLang + targetLang)
        ]

        logger.log("PONS FETCH TRANSLATION START")

        return httpClient
            .send(
                Http(
                    urlString: apiUrl + (query.string ?? ""),
                    method: "GET",
                    headers: ["X-Secret": secret]
                )
            )
            .map { [weak self] data in
                let ponsArray = try JSONDecoder().decode([PonsResponseData].self, from: data)

                self?.logger.log("PONS FETCH TRANSLATION SUCCESS")

                return ponsArray.first?.translation ?? ""
            }
    }
}
