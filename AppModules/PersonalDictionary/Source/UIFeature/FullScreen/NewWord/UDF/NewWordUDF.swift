//
//  NewWordUDF.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 20.06.2024.
//

import CoreModule
import UDF

enum NewWordAction: Action {
    case load
    case textChanged(String)
    case sendNewWord
}

/// Данные модели "Добавления нового слова" в личный словарь.
struct NewWordState: Equatable {
    var text = ""
    var sourceLang = Lang.empty
    var targetLang = Lang.empty
    var langPicker = LangPickerState()
}

struct NewWord {
    
    let langRepository: LangRepository
    let newWordSender: NewWordSender
    let logger: Logger
    
    func reducer(state: inout NewWordState, action: Action) {
        if let action = action as? NewWordAction {
            reducer(state: &state, action: action)
        }
        
        if let action = action as? LangPickerAction {
            reducer(state: &state, action: action)
        }
    }
    
    private func reducer(state: inout NewWordState, action: NewWordAction) {
        switch action {
        case .load:
            state.sourceLang = langRepository.sourceLang
            state.targetLang = langRepository.targetLang
            
        case .textChanged(let text):
            state.text = text
            
        case .sendNewWord:
            let word = Word(
                text: state.text.trimmingCharacters(in: .whitespacesAndNewlines),
                sourceLang: state.sourceLang,
                targetLang: state.targetLang
            )
            
            guard !word.text.isEmpty else { return }
            
            logger.logSending(word, toModelStream: "NEW WORD")
            newWordSender.sendNewWord(word)
        }
    }
    
    private func reducer(state: inout NewWordState, action: LangPickerAction) {
        switch action {
        case .show(let langType):
            state.langPicker = LangPickerState(
                lang: langType == .source ? state.sourceLang : state.targetLang,
                langType: langType,
                isHidden: false
            )
            
        case .hide:
            state.langPicker = LangPickerState()
            
        case .langSelected(let lang):
            let langType = state.langPicker.langType
            var langRepository = langRepository
            
            if langType == .source {
                state.sourceLang = lang
                langRepository.sourceLang = lang
            } else {
                state.targetLang = lang
                langRepository.targetLang = lang
            }
        }
    }
}
