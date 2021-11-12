//
//  SearchTextInputBuilder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 12.11.2021.
//

protocol SearchTextInputBuilder {

    func build(_ listener: SearchTextInputListener) -> SearchTextInputMVVM
}
