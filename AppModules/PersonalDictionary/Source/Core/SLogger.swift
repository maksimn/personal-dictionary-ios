//
//  SLogger.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.03.2023.
//

import CoreModule

extension SLogger {

    func logState(actionName: String, _ state: WordListState) {
        log("Word list \(actionName) result:\n\t\tWord list state: \(state)")
    }

    func log(_ word: Word, fromModelStream modelStreamName: String) {
        log("Received word = \(word) from the \(modelStreamName) model stream.")
    }
}
