//
//  YandexTranslatorResponseData.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

typealias YandexTranslationServiceResult = Result<YandexTranslatorResponseData, Error>

struct YandexTranslatorResponseData: Codable {

    let code: Int

    let text: [String]?

    let message: String?
}
