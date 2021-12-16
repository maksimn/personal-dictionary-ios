//
//  NetworkingService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import RxSwift

protocol TranslationService {

    func fetchTranslation(for wordItem: WordItem) -> Single<String>
}
