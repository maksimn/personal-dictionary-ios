//
//  FindWordDbWorker.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.05.2023.
//

import RealmSwift

protocol FindWordDbWorker {

    func find(id: Word.Id) -> Word?
}

struct FindWordDbWorkerImpl: FindWordDbWorker {

    func find(id: Word.Id) -> Word? {
        do {
            let wordDAO = try Realm().findWordBy(id: id)

            return Word(wordDAO)
        } catch {
            return nil
        }
    }
}
