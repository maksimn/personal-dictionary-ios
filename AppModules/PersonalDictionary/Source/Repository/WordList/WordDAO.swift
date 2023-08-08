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
    @Persisted var dictionaryEntry: List<String>
    @Persisted var sourceLang: LangDAO?
    @Persisted var targetLang: LangDAO?
    @Persisted var isFavorite: Bool
    @Persisted var createdAt: Int

    convenience init(_ word: Word) {
        self.init()
        _id = word.id.raw
        update(from: word)
    }

    func update(from word: Word) {
        text = word.text
        dictionaryEntry.removeAll()
        dictionaryEntry.append(objectsIn: word.dictionaryEntry)
        sourceLang = LangDAO(word.sourceLang)
        targetLang = LangDAO(word.targetLang)
        isFavorite = word.isFavorite
        createdAt = word.createdAt
    }
}

class LangDAO: Object {
    @Persisted var _id: Int
    @Persisted var name: String
    @Persisted var shortName: String

    convenience init(_ lang: Lang) {
        self.init()
        _id = lang.id.raw
        name = lang.name
        shortName = lang.shortName
    }
}

extension Word {

    init?(_ dao: WordDAO) {
        id = .init(raw: dao._id)
        text = dao.text
        dictionaryEntry = Array(dao.dictionaryEntry)

        if let sourceLang = dao.sourceLang,
            let targetLang = dao.targetLang {
            self.sourceLang = Lang(sourceLang)
            self.targetLang = Lang(targetLang)
        } else {
            return nil
        }

        isFavorite = dao.isFavorite
        createdAt = dao.createdAt
    }
}

extension Lang {

    init(_ dao: LangDAO) {
        id = .init(raw: dao._id)
        name = dao.name
        shortName = dao.shortName
    }
}
