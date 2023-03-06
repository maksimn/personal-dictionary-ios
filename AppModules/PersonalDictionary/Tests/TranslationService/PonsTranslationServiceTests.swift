//
//  PonsTranslationServiceTests.swift
//  PersonalDictionaryDevTests
//
//  Created by Maksim Ivanov on 24.02.2023.
//

import RxSwift
import RxBlocking
import XCTest
@testable import PersonalDictionary

final class PonsTranslationServiceTests: XCTestCase {

    func test_fetchTranslation__returnsCorrectTranslation() throws {
        // Arrange:
        let ponsArray = [
            PonsResponseData(
                hits: [
                    PonsResponseDataHit(
                        roms: [
                            PonsResponseDataHitsRom(
                                arabs: [
                                    PonsResponseDataHitsRomsArab(
                                        translations: [
                                            PonsResponseDataHitsRomsArabsTranslation(target: "translation")
                                        ]
                                    )
                                ]
                            )
                        ]
                    )
                ]
            )
        ]
        let data = try JSONEncoder().encode(ponsArray)
        let mockHttpClient = MockHttpClient(returnValue: Single.just(data))
        let ponsTranslationService = PonsTranslationService(
            secret: "",
            httpClient: mockHttpClient,
            logger: LoggerStub()
        )
        let lang = Lang(id: Lang.Id(raw: -1), name: "", shortName: "")
        let word = Word(text: "word", sourceLang: lang, targetLang: lang)

        // Act:
        let single = ponsTranslationService.fetchTranslation(for: word)

        // Assert:
        let result = try single.toBlocking().first()

        XCTAssertEqual(result?.translation, "translation")
    }

    func test_fetchTranslation__returnsErrorWhenHttpRequestFails() throws {
        // Arrange:
        enum HttpError: Error { case unavailable }

        let mockHttpClientError = MockHttpClient(returnValue: Single<Data>.create { observer in
            observer(.error(HttpError.unavailable))
            return Disposables.create { }
        })

        let ponsTranslationService = PonsTranslationService(
            secret: "",
            httpClient: mockHttpClientError,
            logger: LoggerStub()
        )
        let lang = Lang(id: Lang.Id(raw: -1), name: "", shortName: "")
        let word = Word(text: "word", sourceLang: lang, targetLang: lang)

        // Act:
        let single = ponsTranslationService.fetchTranslation(for: word)

        // Assert:
        XCTAssertThrowsError(try single.toBlocking().first())
    }
}
