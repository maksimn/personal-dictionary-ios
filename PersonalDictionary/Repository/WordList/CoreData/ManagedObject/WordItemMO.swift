//
//  WordItemMO.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.10.2021.
//

import CoreData

@objc(WordItemMO)
public class WordItemMO: NSManagedObject {

    @NSManaged public var createdAt: Date?
    @NSManaged public var id: String?
    @NSManaged public var text: String?
    @NSManaged public var sourceLangId: Int
    @NSManaged public var targetLangId: Int

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WordItemMO> {
        return NSFetchRequest<WordItemMO>(entityName: "\(WordItemMO.self)")
    }

    func setData(from wordItem: WordItem) {
        id = wordItem.id.rawValue
        text = wordItem.text
        createdAt = Date(timeIntervalSince1970: TimeInterval(wordItem.createdAt))
        sourceLangId = wordItem.sourceLang.id
        targetLangId = wordItem.targetLang.id
    }

    func convertToWordItem(with langRepository: LangRepository) -> WordItem? {
        let langs = langRepository.allLangs
        guard let id = id,
              let text = text,
              let createdAt = createdAt?.timeIntervalSince1970,
              let sourceLang = langs.first(where: { $0.id == sourceLangId  }),
              let targetLang = langs.first(where: { $0.id == targetLangId  }) else {
            return nil
        }

        return WordItem(id: WordItem.Identifier(rawValue: id),
                        text: text,
                        sourceLang: sourceLang,
                        targetLang: targetLang,
                        createdAt: Int(createdAt))
    }
}
