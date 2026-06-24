//
//  PonsTranslationServiceTests.swift
//  PersonalDictionaryTests
//
//  Created by Maksim Ivanov on 24.02.2023.
//

import CoreModule
import XCTest
@testable import PersonalDictionary

final class PonsDictionaryServiceTests: XCTestCase {

    func test_fetchDictionaryEntry__returnsCorrectTranslation() async throws {
        // Arrange:
        let httpClientMock = HttpClientMock()
        let ponsTranslationService = PonsDictionaryService(secret: "", httpClient: httpClientMock)
        let ponsArray = [
            PonsResponseData(
                hits: [
                    PonsResponseDataHit(
                        roms: [
                            PonsResponseDataHitsRom(
                                headword: "word",
                                wordclass: "",
                                arabs: [
                                    PonsResponseDataHitsRomsArab(
                                        header: "",
                                        translations: [
                                            PonsResponseDataHitsRomsArabsTranslation(
                                                target: "translation",
                                                source: ""
                                            )
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
            HttpResponseResult(response: HTTPURLResponse(), data: data)
        }

        // Act:
        let result = try await ponsTranslationService.fetchDictionaryEntry(for: Word.defaultValueFUT)

        // Assert:
        XCTAssertEqual(result.entry, data)
    }

    func test_fetchDictionaryEntry__returnsErrorWhenHttpRequestFails() async throws {
        // Arrange:
        let httpClientMock = HttpClientMock()
        let ponsTranslationService = PonsDictionaryService(secret: "", httpClient: httpClientMock)

        httpClientMock.sendMock = { _ in
            throw URLError(.unknown)
        }

        // Act & Assert:
        do {
            _ = try await ponsTranslationService.fetchDictionaryEntry(for: Word.defaultValueFUT)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
}
