//
//  WordListViewModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 05.10.2021.
//

/// View model of the word list.
protocol WordListViewModel {

    /// View model data.
    var wordList: BindableWordList { get }

    func select(at position: Int)

    /// Remove a word from the model at the specified index in the list
    /// - Parameters:
    ///  - position: position (index) of the word in the list.
    func remove(at position: Int)

    /// Toggle the "isFavorite" flag value for the word at the specified index in the list
    /// - Parameters:
    ///  - position: position (index) of the word in the list.
    func toggleWordIsFavorite(at position: Int)
}
