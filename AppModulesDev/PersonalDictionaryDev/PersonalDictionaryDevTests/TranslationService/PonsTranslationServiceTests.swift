//
//  PonsTranslationService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import CoreModule
import Cuckoo
import RxSwift
import RxBlocking
import XCTest
@testable import PersonalDictionary

final class PonsTranslationServiceTests: XCTestCase {

    private var mockHttpClient: HttpClient {
        let mockHttpClient = MockHttpClient()

        stub(mockHttpClient) { stub in
            when(stub.send(Http()))
                .thenReturn(Single.just(Data()))
        }

        return mockHttpClient
    }

    func test_fetchTranslation__returnsEmptyStringForEmptyWordTextWhenNetworkAlive() throws {
        // Arrange:
        let mockJsonCoder = MockJsonCoder()
        let ponsTranslationService = PonsTranslationService(
            apiData: PonsApiData(url: "", secretHeaderKey: "", secret: ""),
            httpClient: mockHttpClient,
            jsonCoder: mockJsonCoder,
            logger: LoggerStub()
        )
        let lang = Lang(id: Lang.Id(raw: -1), name: "", shortName: "")
        let word = WordItem(text: "", sourceLang: lang, targetLang: lang)

        stub(mockJsonCoder) { stub in
            when(stub.parseFromJson(Data()))
                .thenReturn(Single.just([] as [PonsResponseData]))
        }

        // Act:
        let single = ponsTranslationService.fetchTranslation(for: word)

        // Assert:
        let result = try single.toBlocking().first()

        XCTAssertEqual(result, "")
    }

    func test_fetchTranslation__returnsTranslationForWordWhenNetworkAlive() throws {
        // Arrange:
        let mockJsonCoder = MockJsonCoder()
        let ponsTranslationService = PonsTranslationService(
            apiData: PonsApiData(url: "", secretHeaderKey: "", secret: ""),
            httpClient: mockHttpClient,
            jsonCoder: mockJsonCoder,
            logger: LoggerStub()
        )
        let lang = Lang(id: Lang.Id(raw: -1), name: "", shortName: "")
        let word = WordItem(text: "word", sourceLang: lang, targetLang: lang)

        stub(mockJsonCoder) { stub in
            when(stub.parseFromJson(Data()))
                .thenReturn(Single.just([
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
                ]))
        }

        // Act:
        let single = ponsTranslationService.fetchTranslation(for: word)

        // Assert:
        let result = try single.toBlocking().first()

        XCTAssertEqual(result, "translation")
    }

    func test_fetchTranslation__returnsErrorWhenNoNetworkConnection() throws {
        // Arrange:
        enum HttpError: Error { case unavailable }

        let mockHttpClientError = MockHttpClient()

        stub(mockHttpClientError) { stub in
            when(stub.send(Http()))
                .thenReturn(Single<Data>.create { observer in
                    observer(.error(HttpError.unavailable))
                    return Disposables.create { }
                })
        }

        let ponsTranslationService = PonsTranslationService(
            apiData: PonsApiData(url: "", secretHeaderKey: "", secret: ""),
            httpClient: mockHttpClientError,
            jsonCoder: JsonCoderStub(),
            logger: LoggerStub()
        )
        let lang = Lang(id: Lang.Id(raw: -1), name: "", shortName: "")
        let word = WordItem(text: "word", sourceLang: lang, targetLang: lang)

        // Act:
        let single = ponsTranslationService.fetchTranslation(for: word)

        // Assert:
        XCTAssertThrowsError(try single.toBlocking().first())
    }
}
