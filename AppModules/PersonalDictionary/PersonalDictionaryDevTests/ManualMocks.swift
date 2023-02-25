//
//  ManualMocks.swift
//  PersonalDictionaryDevTests
//
//  Created by Maksim Ivanov on 24.02.2023.
//

import os
import CoreModule
import RxSwift
@testable import PersonalDictionary

class LoggerStub: CoreModule.Logger {
    func log(_ message: String, _ level: OSLogType) { }
}

class MockHttpClient: HttpClient {

    private let returnValue: Single<Data>

    init(returnValue: Single<Data>) {
        self.returnValue = returnValue
    }

    func send(_ http: Http) -> Single<Data> {
        returnValue
    }
}

class MockLangRepository: LangRepository {

    let allLangsValue: [Lang]
    let defaultLang = Lang(id: .init(raw: 0), name: "", shortName: "")

    init(allLangsValue: [Lang]) {
        self.allLangsValue = allLangsValue
    }

    var allLangs: [Lang] {
        allLangsValue
    }

    lazy var sourceLang: Lang = defaultLang

    lazy var targetLang: Lang = defaultLang
}