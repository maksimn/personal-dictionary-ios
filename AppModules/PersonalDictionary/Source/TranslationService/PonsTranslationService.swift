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
    private let logger: Logger

    private let apiUrl = "https://api.pons.com/v1/dictionary"

    /// - Parameters:
    ///  - secret: секрет для обращения к онлайновому PONS API.
    ///  - httpClient: базовая служба для сетевых запросов по протоколу HTTP.
    ///  - logger: логгер.
    init(secret: String, httpClient: HttpClient, logger: Logger) {
        self.secret = secret
        self.httpClient = httpClient
        self.logger = logger
    }

    func fetchTranslation(for word: Word) -> Single<Word> {
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
                var word = word
                let ponsArray = try JSONDecoder().decode([PonsResponseData].self, from: data)

                self?.logger.log("PONS FETCH TRANSLATION SUCCESS")
                word.translation = ponsArray.first?.translation

                return word
            }
    }
}
