//
//  common.swift
//  PersonalDictionaryTests
//
//  Created by Maksim Ivanov on 24.02.2023.
//

@testable import PersonalDictionary

func removeRealmData() throws {
    _ = try deleteAll(WordDAO.self).toBlocking().first()
    _ = try deleteAll(DictionaryEntryDAO.self).toBlocking().first()
    _ = try deleteAll(WordTranslationIndexDAO.self).toBlocking().first()
}
