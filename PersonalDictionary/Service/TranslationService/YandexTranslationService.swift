//
//  DefaultNetworkService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import Foundation

struct YandexApiData {
    let apiUrl: String
    let apiKey: String
}

final class YandexTranslationService: TranslationService {

    private let coreService: CoreService
    private let jsonCoder: JsonCoder
    private let apiData: YandexApiData

    init(_ apiData: YandexApiData, _ coreService: CoreService, _ jsonCoder: JsonCoder) {
        self.apiData = apiData
        self.coreService = coreService
        self.jsonCoder = jsonCoder
    }

    func fetchTranslation(for wordItem: WordItem, _ completion: @escaping (YandexTranslationServiceResult) -> Void) {
        let key = "key=\(apiData.apiKey)"
        let text = "text=\(wordItem.text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        let lang = "lang=\(wordItem.sourceLang.shortName.lowercased())-\(wordItem.targetLang.shortName.lowercased())"

        coreService.set(urlString: apiData.apiUrl + "?" + key + "&" + text + "&" + lang,
                        httpMethod: "GET",
                        headers: nil)
        coreService.send(nil) { [weak self] result in
            self?.resultHandler(result, completion)
        }
    }

    private func resultHandler(_ result: Result<Data, Error>,
                               _ completion: @escaping (YandexTranslationServiceResult) -> Void) {
        do {
            let data = try result.get()

            jsonCoder.decodeAsync(data) { (result: YandexTranslationServiceResult) in
                switch result {
                case .success(let object):
                    completion(.success(object))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}
