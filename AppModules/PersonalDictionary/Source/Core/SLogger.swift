//
//  SLogger.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.03.2023.
//

import CoreModule

extension SLogger {

    func log(_ word: Word, fromModelStream modelStreamName: String) {
        log("Received word = \(word) from the \(modelStreamName) model stream.")
    }
}
