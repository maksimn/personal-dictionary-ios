//
//  WordMO.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.10.2021.
//

import CoreData

/// Core Data Managed object для хранения данных о слове.
@objc(WordMO)
class WordMO: NSManagedObject {

    /// Идентификатор слова
    @NSManaged var id: String?

    /// Написание слова на исходном языке
    @NSManaged var text: String?

    /// Перевод слова на целевой язык
    @NSManaged var translation: String?

    /// Идентификатор исходного языка
    @NSManaged var sourceLangId: Int

    /// Идентификатор целевого языка
    @NSManaged var targetLangId: Int

    /// Является ли слово избранным
    @NSManaged var isFavorite: Bool

    /// Дата и время создания объекта слова
    @NSManaged var createdAt: Date?

    /// Запрос для получения списка managed object'ов слов
    /// - Returns:
    ///   объект NSFetchRequest для запроса списка слов.
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<WordMO> {
        return NSFetchRequest<WordMO>(entityName: "\(WordMO.self)")
    }

    /// Задать данные из объекта WordItem
    /// - Parameters:
    ///  - word: данные о слове для его сохранения.
    func set(_ word: Word) {
        id = word.id.raw
        text = word.text
        translation = word.translation
        createdAt = Date(timeIntervalSince1970: TimeInterval(word.createdAt))
        sourceLangId = word.sourceLang.id.raw
        targetLangId = word.targetLang.id.raw
        isFavorite = word.isFavorite
    }

    /// Преобразовать WordMO в WordItem
    /// - Parameters:
    ///  - langRepository: хранилище информации о языках.
    /// - Returns:
    ///  - объект WordItem с данными о слове.
    func convert(using langRepository: LangRepository) -> Word? {
        let langs = langRepository.allLangs
        guard let id = id,
              let text = text,
              let createdAt = createdAt?.timeIntervalSince1970,
              let sourceLang = langs.first(where: { $0.id == Lang.Id(raw: sourceLangId)  }),
              let targetLang = langs.first(where: { $0.id == Lang.Id(raw: targetLangId)  }) else {
            return nil
        }

        return Word(
            id: Word.Id(raw: id),
            text: text,
            translation: translation,
            sourceLang: sourceLang,
            targetLang: targetLang,
            isFavorite: isFavorite,
            createdAt: Int(createdAt)
        )
    }
}
