//
//  NewWordModel.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 30.09.2021.
//

protocol NewWordModel {

    var viewModel: NewWordViewModel? { get set }

    func fetchData()

    func sendNewWord()
}
