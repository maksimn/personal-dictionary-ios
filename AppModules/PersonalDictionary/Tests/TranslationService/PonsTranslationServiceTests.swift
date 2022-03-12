//
//  PonsTranslationService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import CoreModule
import RxSwift
import RxBlocking
import XCTest
@testable import PersonalDictionary

fileprivate class HttpClientMock: HttpClient {

    func send(_ http: Http) -> Single<Data> {
        Single.just(Data())
    }
}

fileprivate class JsonCoderMock: JsonCoder {

    func parseFromJson<T>(_ data: Data) -> Single<T> where T : Decodable {
        let ponsResponseDataArray: [PonsResponseData] = []

        return Single.just(ponsResponseDataArray as! T)
    }

    func convertToJson<T>(_ object: T) -> Single<Data> where T : Encodable {
        fatalError()
    }
}

fileprivate class LoggerMock: Logger {

    func networkRequestStart(_ requestName: String) { }

    func networkRequestSuccess(_ requestName: String) { }

    func log(error: Error) { }
}

final class PonsTranslationServiceTests: XCTestCase {

    func test_fetchTranslation__returnsEmptyStringForEmptyWordText() throws {
        // Arrange:
        let ponsTranslationService = PonsTranslationService(
            apiData: PonsApiData(url: "", secretHeaderKey: "", secret: ""),
            httpClient: HttpClientMock(),
            jsonCoder: JsonCoderMock(),
            logger: LoggerMock()
        )
        let lang = Lang(id: Lang.Id(raw: -1), name: "", shortName: "")
        let word = WordItem(text: "", sourceLang: lang, targetLang: lang)

        // Act:
        let single = ponsTranslationService.fetchTranslation(for: word)

        // Assert:
        let result = try single.toBlocking().first()

        XCTAssertEqual(result, "")
    }
}
