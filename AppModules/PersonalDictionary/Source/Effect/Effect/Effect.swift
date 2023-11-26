//
//  Effect.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 25.11.2023.
//

protocol Effect {

    func runCreateWordEffect(_ word: Word)

    func runUpdateWordEffect(_ word: Word)

    func runRemoveWordEffect(_ word: Word)
}
