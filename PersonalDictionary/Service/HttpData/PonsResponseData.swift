//
//  PonsResponseData.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

typealias PonsTranslationServiceResult = Result<[PonsResponseData], Error>

struct PonsResponseData: Codable {
    let hits: [PonsResponseDataHit]

    var translation: String? {
        hits.first?.roms.first?.arabs.first?.translations.first?.target
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
