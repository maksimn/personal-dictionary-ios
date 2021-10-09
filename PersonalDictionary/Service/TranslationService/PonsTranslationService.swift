//
//  PonsTranslationService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import Foundation

struct PonsApiData {
    let url: String
    let secret: String
}

final class PonsTranslationService: TranslationService {

    private let coreService: CoreService
    private let jsonCoder: JsonCoder
    private let apiData: PonsApiData

    init(apiData: PonsApiData, coreService: CoreService, jsonCoder: JsonCoder) {
        self.apiData = apiData
        self.coreService = coreService
        self.jsonCoder = jsonCoder
    }

    func fetchTranslation(for wordItem: WordItem, _ completion: @escaping (PonsTranslationServiceResult) -> Void) {
        let shortSourceLang = wordItem.sourceLang.shortName.lowercased()
        let qParam = "q=\(wordItem.text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        let lParam = "l=\(shortSourceLang)\(wordItem.targetLang.shortName.lowercased())"
        let inParam = "in=\(shortSourceLang)"

        coreService.set(urlString: apiData.url + "?" + lParam + "&" + qParam + "&" + inParam,
                        httpMethod: "GET",
                        headers: ["X-Secret": apiData.secret])
        coreService.send(nil) { [weak self] result in
            self?.resultHandler(result, completion)
        }
    }

    private func resultHandler(_ result: Result<Data, Error>,
                               _ completion: @escaping (PonsTranslationServiceResult) -> Void) {
        do {
            let data = try result.get()

            jsonCoder.decodeAsync(data) { (result: PonsTranslationServiceResult) in
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
