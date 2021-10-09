//
//  NetworkingService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

protocol TranslationService {

    associatedtype Success

    func fetchTranslation(for wordItem: WordItem, _ completion: @escaping (Result<Success, Error>) -> Void)
}
