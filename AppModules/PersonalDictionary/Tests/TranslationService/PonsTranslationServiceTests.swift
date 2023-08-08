//
//  PonsTranslationServiceTests.swift
//  PersonalDictionaryDevTests
//
//  Created by Maksim Ivanov on 24.02.2023.
//

import Combine
import CoreModule
import XCTest
@testable import PersonalDictionary

final class PonsTranslationServiceTests: XCTestCase {

    func test_fetchTranslation__returnsCorrectTranslation() throws {
        // Arrange:
        let httpClientMock = HttpClientMock()
        let ponsTranslationService = PonsTranslationService(
            secret: "",
            httpClient: httpClientMock,
            logger: LoggerMock()
        )
        let lang = Lang(id: Lang.Id(raw: -1), name: "", shortName: "")
        let word = Word(text: "word", sourceLang: lang, targetLang: lang)
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
        let data = try! JSONEncoder().encode(ponsArray)

        httpClientMock.methodMock = { _ in
            RxHttpResponse(CurrentValueSubject((response: HTTPURLResponse(), data: data)))
        }

        // Act:
        let single = ponsTranslationService.fetchTranslation(for: word)

        // Assert:
        let result = try single.toBlocking().first()

        XCTAssertEqual(result?.dictionaryEntry, ["translation"])
    }

    func test_fetchTranslation__returnsErrorWhenHttpRequestFails() throws {
        // Arrange:
        let httpClientMock = HttpClientMock()
        let ponsTranslationService = PonsTranslationService(
            secret: "",
            httpClient: httpClientMock,
            logger: LoggerMock()
        )
        let lang = Lang(id: Lang.Id(raw: -1), name: "", shortName: "")
        let word = Word(text: "word", sourceLang: lang, targetLang: lang)

        httpClientMock.methodMock = { _ in
            RxHttpResponse(Fail(error: URLError(.unknown) as Error))
        }

        // Act:
        let single = ponsTranslationService.fetchTranslation(for: word)

        // Assert:
        XCTAssertThrowsError(try single.toBlocking().first())
    }
}
