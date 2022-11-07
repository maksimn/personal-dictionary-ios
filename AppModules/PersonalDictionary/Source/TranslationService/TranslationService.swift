//
//  NetworkingService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import RxSwift

/// Служба для получения перевода слова.
protocol TranslationService {

    /// Извлечь перевод слова.
    /// - Parameters:
    ///  - wordItem: данные о слове для его перевода.
    /// - Returns:
    ///  - Rx Single, в который завернута строка с переводом заданного слова.
    func fetchTranslation(for wordItem: Word) -> Single<String>
}
