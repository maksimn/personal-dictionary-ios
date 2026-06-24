//
//  RealmTranslationSearchableWordListTests.swift
//  PersonalDictionaryTests
//
//  Created by Maksim Ivanov on 24.02.2023.
//

import XCTest
@testable import PersonalDictionary

class RealmTranslationSearchableWordListTests: XCTestCase {

    let lang = Lang.defaultValueFUT

    lazy var word1 = Word(text: "A", translation: "X", sourceLang: lang, targetLang: lang, createdAt: 3)
    lazy var word2 = Word(text: "B", translation: "Y", sourceLang: lang, targetLang: lang, createdAt: 2)
    lazy var word3 = Word(text: "C", translation: "Q", sourceLang: lang, targetLang: lang, createdAt: 1)

    func arrangeSearch() async throws {
        let createWordDbWorker = RealmCreateWordDbWorker()

        _ = try await createWordDbWorker.create(word: word1)
        _ = try await createWordDbWorker.create(word: word2)
        _ = try await createWordDbWorker.create(word: word3)
    }

    override func tearDownWithError() throws {
        removeRealmData()
    }

    func test_findWordsWhereTranslationContains__returnsTwoWords() async throws {
        // Arrange:
        try await arrangeSearch()

        let ponsArray1 = [
            PonsResponseData(
                hits: [
                    PonsResponseDataHit(
                        roms: [
                            PonsResponseDataHitsRom(
                                headword: "A",
                                wordclass: "",
                                arabs: [
                                    PonsResponseDataHitsRomsArab(
                                        header: "",
                                        translations: [
                                            PonsResponseDataHitsRomsArabsTranslation(
                                                target: "X",
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
        let data1 = try! JSONEncoder().encode(ponsArray1)

        let ponsArray2 = [
            PonsResponseData(
                hits: [
                    PonsResponseDataHit(
                        roms: [
                            PonsResponseDataHitsRom(
                                headword: "B",
                                wordclass: "",
                                arabs: [
                                    PonsResponseDataHitsRomsArab(
                                        header: "",
                                        translations: [
                                            PonsResponseDataHitsRomsArabsTranslation(
                                                target: "Y",
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
        let data2 = try! JSONEncoder().encode(ponsArray2)

        let ponsArray3 = [
            PonsResponseData(
                hits: [
                    PonsResponseDataHit(
                        roms: [
                            PonsResponseDataHitsRom(
                                headword: "C",
                                wordclass: "",
                                arabs: [
                                    PonsResponseDataHitsRomsArab(
                                        header: "",
                                        translations: [
                                            PonsResponseDataHitsRomsArabsTranslation(
                                                target: "Q",
                                                source: ""
                                            ),
                                            PonsResponseDataHitsRomsArabsTranslation(
                                                target: "X",
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
        let data3 = try! JSONEncoder().encode(ponsArray3)

        let createWordTranslationIndexDbWorker = RealmCreateWordTranslationIndexDbWorker(
            decoder: PonsDictionaryEntryDecoder())

        _ = try await createWordTranslationIndexDbWorker.createTranslationIndexFor(
            wordData: .init(word: word1, entry: data1))
        _ = try await createWordTranslationIndexDbWorker.createTranslationIndexFor(
            wordData: .init(word: word2, entry: data2))
        _ = try await createWordTranslationIndexDbWorker.createTranslationIndexFor(
            wordData: .init(word: word3, entry: data3))

        // Act:
        let words = RealmTranslationSearchableWordList().findWords(whereTranslationContains: "X")

        // Assert:
        XCTAssertEqual(words, [word1, word3])
    }
}
