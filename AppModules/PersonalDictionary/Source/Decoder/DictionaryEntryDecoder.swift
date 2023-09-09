//
//  DictionaryEntryDecoder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import Foundation

protocol DictionaryEntryDecoder {

    func decode(_ data: Data, word: Word) throws -> DictionaryEntry
}
