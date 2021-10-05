//
//  NewWordModelImplTests.swift
//  PersonalDictionaryTests
//
//  Created by Maxim Ivanov on 05.10.2021.
//

@testable import PersonalDictionary
import Cuckoo
import XCTest

extension Lang: Matchable {}

class NewWordModelImplTests: XCTestCase {

    let langOne = Lang(name: "a")
    let langTwo = Lang(name: "b")

    func test_fetchData() throws {
        // Arrange:
        var called = false
        var calledTwo = false
        var calledThree = false
        let langs = [langOne, langTwo]
        let mockLangRepository = MockLangRepository()
        let mockViewModel = MockNewWordViewModel()
        let model = NewWordModelImpl(mockLangRepository)

        model.viewModel = mockViewModel

        stub(mockLangRepository) { mockRepository in
            when(mockRepository.allLangs.get).thenReturn(langs)
            when(mockRepository.sourceLang.get).thenReturn(langOne)
            when(mockRepository.targetLang.get).thenReturn(langTwo)
        }
        stub(mockViewModel) { mockVM in
            when(mockVM.allLangs.set(langs)).then { _ in called = true }
            when(mockVM.sourceLang.set(langOne)).then { _ in calledTwo = true }
            when(mockVM.targetLang.set(langTwo)).then { _ in calledThree = true }
        }

        // Act:
        model.fetchData()

        // Assert:
        XCTAssertTrue(called)
        XCTAssertTrue(calledTwo)
        XCTAssertTrue(calledThree)
    }

    func test_saveSourceLang() throws {
        // Arrange:
        var called = false
        let mockLangRepository = MockLangRepository()
        let model = NewWordModelImpl(mockLangRepository)

        stub(mockLangRepository) { mock in
            when(mock.sourceLang.set(langOne)).then { _ in called = true }
        }

        // Act:
        model.save(sourceLang: langOne)

        // Assert:
        XCTAssertTrue(called)
    }

    func test_saveTargetLang() throws {
        // Arrange:
        var called = false
        let mockLangRepository = MockLangRepository()
        let model = NewWordModelImpl(mockLangRepository)

        stub(mockLangRepository) { mock in
            when(mock.targetLang.set(langOne)).then { _ in called = true }
        }

        // Act:
        model.save(targetLang: langOne)

        // Assert:
        XCTAssertTrue(called)
    }
}