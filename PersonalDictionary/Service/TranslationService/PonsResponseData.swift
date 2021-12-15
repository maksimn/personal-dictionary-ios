//
//  PonsResponseData.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

struct PonsResponseData: Codable {
    let hits: [PonsResponseDataHit]

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
