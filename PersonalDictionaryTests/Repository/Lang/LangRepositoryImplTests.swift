//
//  LangRepositoryImplTests.swift
//  PersonalDictionaryTests
//
//  Created by Maxim Ivanov on 04.10.2021.
//

@testable import PersonalDictionary
import XCTest

class LangRepositoryImplTests: XCTestCase {

    var langRepository: LangRepositoryImpl!

    let lang1 = Lang(id: Lang.Id(raw: 1), name: NSLocalizedString("English", comment: ""))
    let lang2 = Lang(id: Lang.Id(raw: 2), name: NSLocalizedString("Russian", comment: ""))
    let lang3 = Lang(id: Lang.Id(raw: 3), name: NSLocalizedString("French", comment: ""))
    let lang4 = Lang(id: Lang.Id(raw: 4), name: NSLocalizedString("Italian", comment: ""))

    lazy var testLangResourceData = LangResourceData(allLangs: [lang1, lang2, lang3, lang4],
                                                     sourceLangKey: "testing.io.github.maksimn.pd.sourceLang",
                                                     targetLangKey: "testing.io.github.maksimn.pd.targetLang",
                                                     defaultSourceLang: lang1,
                                                     defaultTargetLang: lang2)

    override func setUpWithError() throws {
        langRepository = LangRepositoryImpl(userDefaults: UserDefaults.standard, data: testLangResourceData)
    }

    override func tearDownWithError() throws {
        UserDefaults.standard.removeObject(forKey: testLangResourceData.sourceLangKey)
        UserDefaults.standard.removeObject(forKey: testLangResourceData.targetLangKey)
    }

    func test_allLangs__returnsTheSameArrayAsInitArgument() throws {
        let langs = langRepository.allLangs

        XCTAssertEqual(langs, testLangResourceData.allLangs)
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

        XCTAssertEqual(lang, testLangResourceData.defaultSourceLang)
    }

    func test_targetLang__returnsDefaultTargetLang() throws {
        let lang = langRepository.targetLang

        XCTAssertEqual(lang, testLangResourceData.defaultTargetLang)
    }
}
