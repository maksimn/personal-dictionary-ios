//
//  PonsTranslationService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import CoreModule
import RxSwift

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

    private let fetchTranslationRequestName = "PONS FETCH TRANSLATION"

    init(apiData: PonsApiData, coreService: CoreService, jsonCoder: JsonCoder, logger: Logger) {
        self.apiData = apiData
        self.coreService = coreService
        self.jsonCoder = jsonCoder
        self.logger = logger
    }

    func fetchTranslation(for wordItem: WordItem) -> Single<String> {
        let shortSourceLang = wordItem.sourceLang.shortName.lowercased()
        let qParam = "q=\(wordItem.text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        let lParam = "l=\(shortSourceLang)\(wordItem.targetLang.shortName.lowercased())"

        logger.networkRequestStart(fetchTranslationRequestName)
        return coreService
            .send(Http(urlString: apiData.url + "?" + lParam + "&" + qParam,
                       method: "GET",
                       headers: [apiData.secretHeaderKey: apiData.secret],
                       body: nil))
            .map { [weak self] data -> Single<[PonsResponseData]> in
                self?.jsonCoder.parseFromJson(data) ?? Single.just([])
            }
            .asObservable().concat().asSingle()
            .map { [weak self] ponsResponseArray in
                guard let self = self else { return "" }
                self.logger.networkRequestSuccess(self.fetchTranslationRequestName)
                return ponsResponseArray.first?.translation ?? ""
            }
    }
}
