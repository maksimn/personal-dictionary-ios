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
                                          notificationCenter: NotificationCenter.default,
                                          viewParams: NewWordViewParams(
                                            staticContent: NewWordViewStaticContent(selectButtonTitle: "",
                                                                                    arrowText: "",
                                                                                    okText: "",
                                                                                    textFieldPlaceholder: ""),
                                            styles: NewWordViewStyles(backgroundColor: .clear)))

        XCTAssertNotNil(newWordMVVM.viewController)
    }
}
