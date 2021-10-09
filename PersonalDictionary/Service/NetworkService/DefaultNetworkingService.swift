//
//  DefaultNetworkService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import Foundation

final class DefaultNetworkingService: NetworkingService {

    private let coreService: CoreService
    private let jsonCoder: JsonCoder
    private let apiData: WebApiData

    init(_ apiData: WebApiData, _ coreService: CoreService, _ jsonCoder: JsonCoder) {
        self.apiData = apiData
        self.coreService = coreService
        self.jsonCoder = jsonCoder
    }

    func fetchTranslation(for wordItem: WordItem, _ completion: @escaping (TranslationResult) -> Void) {
        let aaa = "https://translate.yandex.net/api/v1.5/tr.json/translate"
        let key = "key=\(apiData.yandexTranslatorApiKey)"
        let text = "text=\(wordItem.text)"
        let lang = "lang=\(wordItem.sourceLang.shortName)-\(wordItem.targetLang.shortName)"

        coreService.set(urlString: aaa + "?" + key + "&" + text + "&" + lang,
                        httpMethod: "GET",
                        headers: nil)
        coreService.send(nil) { [weak self] result in
            self?.getRequestHandler(result, completion)
        }
    }

    private func getRequestHandler(_ result: Result<Data, Error>,
                                   _ completion: @escaping (TranslationResult) -> Void) {
        do {
            let data = try result.get()

            jsonCoder.decodeAsync(data) { (result: TranslationResult) in
                switch result {
                case .success(let array):
                    completion(.success(array))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}
