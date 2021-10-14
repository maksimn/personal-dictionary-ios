//
//  WordListModelImpl+Events.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 13.10.2021.
//

import Foundation

extension WordListModelImpl {

    @objc
    func addObservers() {
        notificationCenter.addObserver(self, selector: #selector(onAddNewWordItem), name: .addNewWord, object: nil)
        notificationCenter.addObserver(self, selector: #selector(onRemoveWordItem), name: .removeWord, object: nil)
    }

    @objc
    func onAddNewWordItem(_ notification: Notification) {
        if let wordItem = notification.userInfo?[Notification.Name.addNewWord] as? WordItem {
            add(wordItem)
        }
    }

    @objc
    func onRemoveWordItem(_ notification: Notification) {
        if let wordItem = notification.userInfo?[Notification.Name.removeWord] as? WordItem {
            remove(wordItem: wordItem)
        }
    }
}
