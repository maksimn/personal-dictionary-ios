//
//  WordItemMO.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.10.2021.
//

import CoreData

/// Core Data Managed object для хранения данных о слове.
@objc(WordItemMO)
class WordItemMO: NSManagedObject {

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

    /// Дата и время создания объекта слова
    @NSManaged var createdAt: Date?

    /// Запрос для получения списка managed object'ов слов
    /// - Returns:
    ///   объект NSFetchRequest для запроса списка слов.
    @nonobjc
    class func fetchRequest() -> NSFetchRequest<WordItemMO> {
        return NSFetchRequest<WordItemMO>(entityName: "\(WordItemMO.self)")
    }

    /// Задать данные из объекта WordItem
    /// - Parameters:
    ///  - wordItem: данные о слове для его сохранения.
    func setData(from wordItem: WordItem) {
        id = wordItem.id.raw
        text = wordItem.text
        translation = wordItem.translation
        createdAt = Date(timeIntervalSince1970: TimeInterval(wordItem.createdAt))
        sourceLangId = wordItem.sourceLang.id.raw
        targetLangId = wordItem.targetLang.id.raw
    }

    /// Преобразовать WordItemMO в WordItem
    /// - Parameters:
    ///  - langRepository: хранилище информации о языках.
    /// - Returns:
    ///   объект WordItem с данными о слове.
    func convertToWordItem(with langRepository: LangRepository) -> WordItem? {
        let langs = langRepository.allLangs
        guard let id = id,
              let text = text,
              let createdAt = createdAt?.timeIntervalSince1970,
              let sourceLang = langs.first(where: { $0.id == Lang.Id(raw: sourceLangId)  }),
              let targetLang = langs.first(where: { $0.id == Lang.Id(raw: targetLangId)  }) else {
            return nil
        }

        return WordItem(id: WordItem.Id(raw: id),
                        text: text,
                        translation: translation,
                        sourceLang: sourceLang,
                        targetLang: targetLang,
                        createdAt: Int(createdAt))
    }
}
