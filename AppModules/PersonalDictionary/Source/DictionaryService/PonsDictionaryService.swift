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
final class PonsDictionaryService: DictionaryService {

    private let secret: String
    private let httpClient: HttpClient

    private let apiUrl = "https://api.pons.com/v1/dictionary"

    private var cancellables: Set<AnyCancellable> = []

    /// - Parameters:
    ///  - secret: секрет для обращения к онлайновому PONS API.
    ///  - httpClient: базовая служба для сетевых запросов по протоколу HTTP.
    init(secret: String, httpClient: HttpClient) {
        self.secret = secret
        self.httpClient = httpClient
    }

    func fetchDictionaryEntry(for word: Word) -> Single<WordData> {
        var query = URLComponents()

        query.queryItems = [
            URLQueryItem(name: "q", value: word.text),
            URLQueryItem(name: "l", value: lQueryParam(for: word))
        ]

        let http = Http(
            urlString: apiUrl + (query.string ?? ""),
            headers: ["X-Secret": secret]
        )

        return transformToRxObservable(
                httpClient.send(http)
            )
            .take(1)
            .asSingle()
            .map { httpResponse in
                WordData(word: word, entry: httpResponse.data)
            }
    }

    private func lQueryParam(for word: Word) -> String {
        let sourceLang = word.sourceLang.shortNameKey.raw
        let targetLang = word.targetLang.shortNameKey.raw
        guard let sourceLangIndex = sourceLang.firstIndex(of: "_") else { return "" }
        guard let targetLangIndex = targetLang.firstIndex(of: "_") else { return "" }
        let sourceLangParam = sourceLang.suffix(from: sourceLang.index(sourceLangIndex, offsetBy: 1)).lowercased()
        let targetLangParam = targetLang.suffix(from: targetLang.index(targetLangIndex, offsetBy: 1)).lowercased()

        return sourceLangParam + targetLangParam
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
