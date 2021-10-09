//
//  NetworkingService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

typealias TranslationResult = Result<YandexTranslatorResponseData, Error>

protocol NetworkingService {

    func fetchTranslation(for wordItem: WordItem, _ completion: @escaping (TranslationResult) -> Void)
}
