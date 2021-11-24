//
//  PonsTranslationService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

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

    func fetchTranslation(for wordItem: WordItem, _ completion: @escaping (TranslationServiceResult) -> Void) {
        let shortSourceLang = wordItem.sourceLang.shortName.lowercased()
        let qParam = "q=\(wordItem.text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        let lParam = "l=\(shortSourceLang)\(wordItem.targetLang.shortName.lowercased())"
        let inParam = "in=\(shortSourceLang)"

        logger.networkRequestStart(fetchTranslationRequestName)
        coreService
            .send(Http(urlString: apiData.url + "?" + lParam + "&" + qParam + "&" + inParam,
                       method: "GET",
                       headers: [apiData.secretHeaderKey: apiData.secret],
                       body: nil))
            .map { data -> Single<[PonsResponseData]> in
                self.jsonCoder.parseFromJson(data)
            }
            .asObservable().concat().asSingle()
            .subscribe(
                onSuccess: { ponsResponseArray in
                    let translation = ponsResponseArray.first?.translation ?? ""

                    self.logger.networkRequestSuccess(self.fetchTranslationRequestName)
                    completion(.success(translation))
                },
                onError: { error in
                    self.completionWithLog(error, completion)
                })
            .disposed(by: disposeBag)
    }

    private func completionWithLog(_ error: Error, _ completion: @escaping (TranslationServiceResult) -> Void) {
        self.logger.networkRequestError(self.fetchTranslationRequestName)
        self.logger.log(error: error)
        completion(.failure(error))
    }

    private let disposeBag = DisposeBag()
}
