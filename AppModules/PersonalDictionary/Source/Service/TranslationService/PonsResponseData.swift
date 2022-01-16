//
//  PonsResponseData.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

/// Структура с данными после парсинга "сырого" JSON ответа PONS API.
/// См. документацию к API: https://ru.pons.com/p/files/uploads/pons/api/api-documentation.pdf
struct PonsResponseData: Codable {

    /// Интересующее нас поле из JSON ответа PONS API.
    let hits: [PonsResponseDataHit]
}

extension PonsResponseData {

    /// Получение запрошенного перевод слова
    /// - Returns:
    ///   перевод слова на целевой язык.
    var translation: String? {
        guard let str = hits.first?.roms.first?.arabs.first?.translations.first?.target else { return nil }

        if let end = str.firstIndex(of: "<") {
            return String(str[..<end])
        }

        return str
    }
}

struct PonsResponseDataHit: Codable {
    let roms: [PonsResponseDataHitsRom]
}

struct PonsResponseDataHitsRom: Codable {
    let arabs: [PonsResponseDataHitsRomsArab]
}

struct PonsResponseDataHitsRomsArab: Codable {
    let translations: [PonsResponseDataHitsRomsArabsTranslation]
}

struct PonsResponseDataHitsRomsArabsTranslation: Codable {
    let target: String
}
