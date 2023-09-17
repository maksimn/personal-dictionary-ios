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

final class PonsDictionaryServiceTests: XCTestCase {

    func test_fetchDictionaryEntry__returnsCorrectTranslation() throws {
        // Arrange:
        let httpClientMock = HttpClientMock()
        let ponsTranslationService = PonsDictionaryService(
            secret: "",
            httpClient: httpClientMock
        )
        let lang = Lang(id: .init(raw: -1), nameKey: .init(raw: ""), shortNameKey: .init(raw: ""))
        let word = Word(text: "word", sourceLang: lang, targetLang: lang)
        let ponsArray = [
            PonsResponseData(
                hits: [
                    PonsResponseDataHit(
                        roms: [
                            PonsResponseDataHitsRom(
                                headword: "word",
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

        httpClientMock.sendMock = { _ in
            RxHttpResponse(CurrentValueSubject((response: HTTPURLResponse(), data: data)))
        }

        // Act:
        let single = ponsTranslationService.fetchDictionaryEntry(for: word)

        // Assert:
        let result = try single.toBlocking().first()

        XCTAssertEqual(result?.entry, data)
    }

    func test_fetchDictionaryEntry__returnsErrorWhenHttpRequestFails() throws {
        // Arrange:
        let httpClientMock = HttpClientMock()
        let ponsTranslationService = PonsDictionaryService(
            secret: "",
            httpClient: httpClientMock
        )
        let lang = Lang(id: .init(raw: -1), nameKey: .init(raw: ""), shortNameKey: .init(raw: ""))
        let word = Word(text: "word", sourceLang: lang, targetLang: lang)

        httpClientMock.sendMock = { _ in
            RxHttpResponse(Fail(error: URLError(.unknown) as Error))
        }

        // Act:
        let single = ponsTranslationService.fetchDictionaryEntry(for: word)

        // Assert:
        XCTAssertThrowsError(try single.toBlocking().first())
    }
}
