//
//  DictionaryEntry.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 17.10.2023.
//

import CoreModule

typealias DictionaryEntry = [DictionaryEntryItem]

struct DictionaryEntryItem: Equatable {
    let title: String
    let subtitle: LocalizableStringKey
    let subitems: [DictionaryEntrySubitem]
}

struct DictionaryEntrySubitem: Equatable, CustomStringConvertible {
    let translation: String
    let context: [LocalizableStringKey]
    let example: String?

    init(translation: String, context: [LocalizableStringKey] = [], example: String?) {
        self.translation = translation
        self.context = context
        self.example = example
    }

    var description: String {
        """
        DictionaryEntrySubitem(translation: \(translation), \
        context: \(context.map { $0.key }), \
        example: \(example ?? "nil"))
        """
    }
}

extension DictionaryEntry {

    var mainTranslation: String {
        first?.subitems.first?.translation ?? ""
    }
}
