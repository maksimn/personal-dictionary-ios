//
//  PonsTranslationService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import Combine
import CoreModule
import Foundation
import RxSwift

/// Служба для получения перевода слова из PONS Online Dictionary API,
final class PonsTranslationService: TranslationService {

    private let httpClient: HttpClient
    private let secret: String
    private let logger: Logger

    private let apiUrl = "https://api.pons.com/v1/dictionary"

    private var cancellables: Set<AnyCancellable> = []

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

        let http = Http(
            urlString: apiUrl + (query.string ?? ""),
            method: "GET",
            headers: ["X-Secret": secret]
        )

        logger.log("PONS FETCH TRANSLATION START, word = \(word)", level: .info)
        logger.log("HTTP REQUEST START, \(http)", level: .info)

        return transformToRxObservable(
                httpClient.send(http)
            )
            .do(
                onNext: { httpResponse in
                    self.logger.log("""
                        HTTP RESPONSE FETCHED
                        HTTPURLResponse: \(httpResponse.response)
                        Data: \(String(decoding: httpResponse.data, as: UTF8.self))
                    """, level: .info)
                },
                onError: { error in
                    self.logger.log("HTTP REQUEST ERROR, \(error)", level: .error)
                }
            )
            .take(1)
            .asSingle()
            .map { httpResponse in
                let data = httpResponse.data
                var word = word
                let ponsArray = try JSONDecoder().decode([PonsResponseData].self, from: data)

                word.translation = ponsArray.first?.translation

                return word
            }
            .do(
                onSuccess: { word in
                    self.logger.log("PONS FETCH TRANSLATION SUCCESS, word = \(word)", level: .info)
                },
                onError: { error in
                    self.logger.log("PONS FETCH TRANSLATION ERROR, word = \(word)", level: .error)
                }
            )
    }

    private func transformToRxObservable(_ rxHttpResponse: RxHttpResponse) -> Observable<(response: HTTPURLResponse,
                                                                                          data: Data)> {
        .create { observer in
            rxHttpResponse.sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        observer.on(.error(error))
                    case .finished:
                        observer.on(.completed)
                    }
                },
                receiveValue: { httpResponse in
                    observer.on(.next(httpResponse))
                }
            ).store(in: &self.cancellables)

            return Disposables.create { }
        }
    }
}
