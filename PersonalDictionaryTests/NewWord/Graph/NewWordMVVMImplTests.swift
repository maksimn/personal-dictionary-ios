//
//  NewWordMVVMImplTests.swift
//  PersonalDictionaryTests
//
//  Created by Maxim Ivanov on 05.10.2021.
//

@testable import PersonalDictionary
import XCTest

class NewWordMVVMImplTests: XCTestCase {

    func test_mvvmGraphOutputNotNil() throws {
        let mockLangRepository = MockLangRepository()
        let newWordMVVM = NewWordMVVMImpl(langRepository: mockLangRepository,
                                          notificationCenter: NotificationCenter.default)

        XCTAssertNotNil(newWordMVVM.viewController)
    }
}
