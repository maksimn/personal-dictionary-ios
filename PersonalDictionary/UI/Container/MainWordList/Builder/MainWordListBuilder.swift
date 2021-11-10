//
//  MainWordListBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

protocol MainWordListBuilder {

    func build() -> MainWordListGraph

    func createNewWordBuilder() -> NewWordBuilder

    func buildSearchWordMVVM() -> WordListMVVM
}
