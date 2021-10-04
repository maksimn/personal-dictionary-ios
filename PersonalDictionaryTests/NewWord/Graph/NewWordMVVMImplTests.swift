//
//  NewWordMVVMImplTests.swift
//  PersonalDictionaryTests
//
//  Created by Maxim Ivanov on 05.10.2021.
//

@testable import PersonalDictionary
import XCTest

class NewWordMVVMImplTests: XCTestCase {

    let newWordViewResource = NewWordViewResource(selectButtonTitle: "", arrowText: "", okText: "",
                                                  textFieldPlaceholder: "", backgroundColor: .clear)

    func test_mvvmGraphOutputNotNil() throws {
        let mockLangRepository = MockLangRepository()
        let newWordMVVM = NewWordMVVMImpl(langRepository: mockLangRepository,
                                          viewResource: newWordViewResource)

        XCTAssertNotNil(newWordMVVM.viewController)
    }
}
