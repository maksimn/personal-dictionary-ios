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

    let langOne = Lang(id: Lang.Id(raw: 1), name: "a", shortName: "a")
    let langTwo = Lang(id: Lang.Id(raw: 2), name: "b", shortName: "b")
}
