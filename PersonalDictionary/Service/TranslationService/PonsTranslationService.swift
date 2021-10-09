//
//  PonsTranslationService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import Foundation

typealias PonsTranslationServiceResult = Result<PonsResponseData, Error>

struct PonsResponseData: Codable {

}

struct PonsApiData {
    let url: String
    let secret: String
}

final class PonsTranslationService: TranslationService {

    private let coreService: CoreService
    private let jsonCoder: JsonCoder
    private let apiData: PonsApiData

    init(_ apiData: PonsApiData, _ coreService: CoreService, _ jsonCoder: JsonCoder) {
        self.apiData = apiData
        self.coreService = coreService
        self.jsonCoder = jsonCoder
    }

    func fetchTranslation(for wordItem: WordItem, _ completion: @escaping (PonsTranslationServiceResult) -> Void) {
        let qParam = "q=\(wordItem.text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        let lParam = "l=\(wordItem.sourceLang.shortName.lowercased())\(wordItem.targetLang.shortName.lowercased())"

        coreService.set(urlString: apiData.url + "?" + lParam + "&" + qParam,
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
