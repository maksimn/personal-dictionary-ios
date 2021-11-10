//
//  WordListBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 14.10.2021.
//

protocol WordListBuilder {

    func buildMainWordListContainer() -> MainWordListContainer

    func buildMVVM() -> WordListMVVM

    func buildNewWordMVVM() -> NewWordMVVM

    func buildSearchWordMVVM() -> WordListMVVM
}