//
//  UDLangRepositoryTests.swift
//  PersonalDictionaryTests
//
//  Created by Maxim Ivanov on 04.10.2021.
//

@testable import PersonalDictionary
import XCTest

class UDLangRepositoryTests: XCTestCase {

    var langRepository: UDLangRepository!

    let lang1 = Lang(id: Lang.Id(raw: 1), nameKey: .init(raw: "English"), shortNameKey: .init(raw: "a"))
    let lang2 = Lang(id: Lang.Id(raw: 2), nameKey: .init(raw: "Russian"), shortNameKey: .init(raw: "b"))
    let lang3 = Lang(id: Lang.Id(raw: 3), nameKey: .init(raw: "Italian"), shortNameKey: .init(raw: "c"))
    let lang4 = Lang(id: Lang.Id(raw: 4), nameKey: .init(raw: "German"), shortNameKey: .init(raw: "d"))

    lazy var testLangData = LangData(
        allLangs: [lang1, lang2, lang3, lang4],
        sourceLangKey: "testing.io.github.maksimn.pd.sourceLang",
        targetLangKey: "testing.io.github.maksimn.pd.targetLang",
        defaultSourceLang: lang1,
        defaultTargetLang: lang2
    )

    override func setUpWithError() throws {
        langRepository = UDLangRepository(userDefaults: UserDefaults.standard, data: testLangData)
    }

    override func tearDownWithError() throws {
        UserDefaults.standard.removeObject(forKey: testLangData.sourceLangKey)
        UserDefaults.standard.removeObject(forKey: testLangData.targetLangKey)
    }

    func test_allLangs__returnsTheSameArrayAsInitArgument() throws {
        let langs = langRepository.allLangs

        XCTAssertEqual(langs, testLangData.allLangs)
    }

    func test_sourceLang__returnsTheLangThatWasSet() throws {
        langRepository.sourceLang = lang3

        XCTAssertEqual(langRepository.sourceLang, lang3)
    }

    func test_targetLang__returnsTheLangThatWasSet() throws {
        langRepository.targetLang = lang4

        XCTAssertEqual(langRepository.targetLang, lang4)
    }

    func test_sourceLang__returnsDefaultSourceLang() throws {
        let lang = langRepository.sourceLang

        XCTAssertEqual(lang, testLangData.defaultSourceLang)
    }

    func test_targetLang__returnsDefaultTargetLang() throws {
        let lang = langRepository.targetLang

        XCTAssertEqual(lang, testLangData.defaultTargetLang)
    }
}
