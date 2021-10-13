//
//  WordListModelImpl+Events.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.10.2021.
//

import Foundation

extension WordListModelImpl {

    func addObservers() {
        notificationCenter.addObserver(self, selector: #selector(onAddNewWordItem), name: .addNewWord, object: nil)
    }

    @objc
    func onAddNewWordItem(_ notification: Notification) {
        if let wordItem = notification.userInfo?[Notification.Name.addNewWord] as? WordItem {
            add(wordItem)
        }
    }
}
