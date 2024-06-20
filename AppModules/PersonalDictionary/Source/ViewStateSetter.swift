//
//  ViewStateSetter.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 20.06.2024.
//

protocol ViewStateSetter<ViewState>: AnyObject {
    
    associatedtype ViewState
    
    func setViewState(_ state: ViewState)
}
