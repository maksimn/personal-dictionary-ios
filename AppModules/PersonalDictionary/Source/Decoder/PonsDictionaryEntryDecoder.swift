//
//  PonsTranslationDecoder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import CoreModule
import Foundation

private let wordclassMapper = [
    "adjective": "LS_ADJECTIVE",
    "adverb": "LS_ADVERB",
    "article": "LS_ARTICLE",
    "conjunction": "LS_CONJUNCTION",
    "intransitive verb": "LS_VERB",
    "noun": "LS_NOUN",
    "numeral": "LS_NUMERAL",
    "participle": "LS_PARTICIPLE",
    "particle": "LS_PARTICLE",
    "preposition": "LS_PREPOSITION",
    "pronoun": "LS_PRONOUN",
    "transitive verb": "LS_VERB",
    "verb": "LS_VERB"
]
private let redundantParts = [
    "Aus", "Aus,",
    "Am", "Am,",
    "Brit", "Brit,",
    "CINE", "CINE,",
    "f", "f,",
    "fig", "fig,",
    "inf", "inf,",
    "LIT", "LIT,",
    "m", "m,",
    "nt", "nt,"
]
private let contexts = [
    "Am": "LS_AM_ENG",
    "Aus": "LS_AUS_ENG",
    "Brit": "LS_BR_ENG"
]

struct PonsDictionaryEntryDecoder: DictionaryEntryDecoder {

    func decode(_ data: Data) throws -> DictionaryEntry {
        let ponsArray = try JSONDecoder().decode([PonsResponseData].self, from: data)
        let items: [DictionaryEntryItem?] = ponsArray.flatMap { $0.hits }
            .flatMap { $0.roms }
            .map {
                let title = $0.headword
                guard let wordclass = $0.wordclass else { return nil }

                return DictionaryEntryItem(
                    title: title,
                    subtitle: LocalizableStringKey(wordclassMapper[wordclass] ?? "", bundle: Bundle.module),
                    subitems: $0.arabs
                        .flatMap {
                            let context = Self.parseContextFrom($0.header)

                            return $0.translations.map {
                                let example = Self.stripOutTags(from: $0.source, andRemove: redundantParts)
                                let translation = Self.stripOutTags(from: $0.target, andRemove: redundantParts)

                                return DictionaryEntrySubitem(
                                    translation: translation,
                                    context: context,
                                    example: example.lowercased() == title.lowercased() ? nil : example
                                )
                            }
                        }
                )
            }

        return Self.itemsGroupedByTitleAndSubtitle(items.compactMap { $0 })
    }

    static func itemsGroupedByTitleAndSubtitle(_ items: DictionaryEntry) -> DictionaryEntry {
        var items = items

        for i in 0..<items.count {
            guard i + 1 < items.count else { break }

            for j in (i + 1)..<items.count {
                guard let one = items[safeIndex: i] else { break }
                guard let two = items[safeIndex: j] else { break }

                if one.title == two.title && one.subtitle == two.subtitle {
                    var subitems = one.subitems

                    subitems.append(contentsOf: two.subitems)

                    items[i] = .init(title: one.title, subtitle: one.subtitle, subitems: subitems)
                    items.remove(at: j)
                }
            }
        }

        return items
    }

    static func parseContextFrom(_ str: String) -> [LocalizableStringKey] {
        let parts = str.stripOutTags().split(separator: " ")
        var result: [LocalizableStringKey] = []

        for part in parts {
            for key in contexts.keys where part.starts(with: key) {
                result.append(LocalizableStringKey(contexts[key] ?? "", bundle: Bundle.module))
            }
        }

        return result
    }

    static func stripOutTags(from string: String, andRemove redundantParts: [String] = []) -> String {
        let parts = string.stripOutTags().split(separator: " ")
        var result: [String] = []

        for part in parts {
            var isRedundant = false

            for redundant in redundantParts where part == redundant {
                isRedundant = true
            }

            if !isRedundant {
                result.append(String(part))
            }
        }

        return result.joined(separator: " ")
    }
}

/// Структура с данными после парсинга "сырого" JSON ответа PONS API.
/// См. документацию к API: https://www.pons.com/p/files/uploads/pons/api/api-documentation.pdf
struct PonsResponseData: Codable {
    let hits: [PonsResponseDataHit]
}

struct PonsResponseDataHit: Codable {
    let roms: [PonsResponseDataHitsRom]
}

struct PonsResponseDataHitsRom: Codable {
    let headword: String
    let wordclass: String?
    let arabs: [PonsResponseDataHitsRomsArab]
}

struct PonsResponseDataHitsRomsArab: Codable {
    let header: String
    let translations: [PonsResponseDataHitsRomsArabsTranslation]
}

struct PonsResponseDataHitsRomsArabsTranslation: Codable {
    let target: String
    let source: String
}
