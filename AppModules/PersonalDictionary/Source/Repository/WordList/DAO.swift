//
//  WordDAO.swift
//  
//
//  Created by Maksim Ivanov on 10.05.2023.
//

import Foundation
import RealmSwift

class WordDAO: Object {
    @Persisted(primaryKey: true) var _id: String
    @Persisted var text: String
    @Persisted var translation: String?
    @Persisted var sourceLang: LangDAO?
    @Persisted var targetLang: LangDAO?
    @Persisted var isFavorite: Bool
    @Persisted var createdAt: Int
    @Persisted var updatedAt: Int

    convenience init(_ word: Word) {
        self.init()
        _id = word.id.raw
        update(from: word)
    }

    func update(from word: Word) {
        text = word.text
        translation = word.translation
        sourceLang = LangDAO(word.sourceLang)
        targetLang = LangDAO(word.targetLang)
        isFavorite = word.isFavorite
        createdAt = word.createdAt
        updatedAt = word.updatedAt
    }
}

class LangDAO: Object {
    @Persisted var _id: Int
    @Persisted var name: String
    @Persisted var shortName: String

    convenience init(_ lang: Lang) {
        self.init()
        _id = lang.id.raw
        name = lang.nameKey.raw
        shortName = lang.shortNameKey.raw
    }
}

class DictionaryEntryDAO: Object {

    @Persisted(primaryKey: true) var _id: String
    @Persisted var entry: Data

    convenience init(_ id: Word.Id, _ entry: Data) {
        self.init()
        _id = id.raw
        self.entry = entry
    }
}

extension Word {

    init?(_ dao: WordDAO) {
        id = .init(raw: dao._id)
        text = dao.text
        translation = dao.translation ?? ""

        if let sourceLang = dao.sourceLang,
            let targetLang = dao.targetLang {
            self.sourceLang = Lang(sourceLang)
            self.targetLang = Lang(targetLang)
        } else {
            return nil
        }

        isFavorite = dao.isFavorite
        createdAt = dao.createdAt
        updatedAt = dao.updatedAt
    }
}

extension Lang {

    init(_ dao: LangDAO) {
        id = .init(raw: dao._id)
        nameKey = .init(raw: dao.name)
        shortNameKey = .init(raw: dao.shortName)
    }
}
