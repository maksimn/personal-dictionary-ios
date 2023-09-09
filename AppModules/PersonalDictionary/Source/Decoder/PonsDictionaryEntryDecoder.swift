//
//  PonsTranslationDecoder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import Foundation

struct PonsDictionaryEntryDecoder: DictionaryEntryDecoder {

    func decode(_ data: Data, word: Word) throws -> DictionaryEntry {
        let ponsArray = try JSONDecoder().decode([PonsResponseData].self, from: data)
        let ponsData = ponsArray.first ?? PonsResponseData(hits: [])
        let translations = ponsData.hits
            .map { $0.roms }
            .flatMap { $0 }
            .filter { $0.headword.lowercased() == word.text.lowercased() }
            .flatMap { $0.arabs }
            .flatMap { $0.translations }
            .map { $0.target }
            .map { str in
                if let endIndex = str.firstIndex(of: "<") {
                    guard endIndex > str.startIndex && str.index(before: endIndex) > str.startIndex else {
                        return ""
                    }

                    return String(str[..<str.index(before: endIndex)])
                } else {
                    return str
                }
            }
            .filter { !$0.isEmpty }
            .removingDuplicates()

        return translations
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
    let arabs: [PonsResponseDataHitsRomsArab]
}

struct PonsResponseDataHitsRomsArab: Codable {
    let translations: [PonsResponseDataHitsRomsArabsTranslation]
}

struct PonsResponseDataHitsRomsArabsTranslation: Codable {
    let target: String
}
