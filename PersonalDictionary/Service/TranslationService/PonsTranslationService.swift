//
//  PonsTranslationService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import Foundation

struct PonsApiData {
    let url: String
    let secretHeaderKey: String
    let secret: String
}

final class PonsTranslationService: TranslationService {

    private let coreService: CoreService
    private let jsonCoder: JsonCoder
    private let apiData: PonsApiData
    private let logger: Logger

    private let fetchTranslationRequestName = "FETCH TRANSLATION"

    init(apiData: PonsApiData, coreService: CoreService, jsonCoder: JsonCoder, logger: Logger) {
        self.apiData = apiData
        self.coreService = coreService
        self.jsonCoder = jsonCoder
        self.logger = logger
    }

    func fetchTranslation(for wordItem: WordItem, _ completion: @escaping (TranslationServiceResult) -> Void) {
        let shortSourceLang = wordItem.sourceLang.shortName.lowercased()
        let qParam = "q=\(wordItem.text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        let lParam = "l=\(shortSourceLang)\(wordItem.targetLang.shortName.lowercased())"
        let inParam = "in=\(shortSourceLang)"

        logger.networkRequestStart(fetchTranslationRequestName)
        coreService.set(urlString: apiData.url + "?" + lParam + "&" + qParam + "&" + inParam,
                        httpMethod: "GET",
                        headers: [apiData.secretHeaderKey: apiData.secret])
        coreService.send(nil) { [weak self] result in
            self?.resultHandler(result, completion)
        }
    }

    private func resultHandler(_ result: Result<Data, Error>,
                               _ completion: @escaping (TranslationServiceResult) -> Void) {
        do {
            let data = try result.get()

            jsonCoder.decodeAsync(data) { (result: Result<[PonsResponseData], Error>) in
                switch result {
                case .success(let ponsResponseArray):
                    let translation = ponsResponseArray.first?.translation ?? ""

                    self.logger.networkRequestSuccess(self.fetchTranslationRequestName)
                    completion(.success(translation))
                case .failure(let error):
                    self.completionWithLog(error, completion)
                }
            }
        } catch {
            completionWithLog(error, completion)
        }
    }

    private func completionWithLog(_ error: Error, _ completion: @escaping (TranslationServiceResult) -> Void) {
        self.logger.networkRequestError(self.fetchTranslationRequestName)
        self.logger.log(error: error)
        completion(.failure(error))
    }
}
