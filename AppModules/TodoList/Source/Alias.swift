//
//  Alias.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 20.01.2023.
//

import ComposableArchitecture

typealias TodoListCallback = (Result<[Todo], Error>) -> Void
typealias VoidCallback = (Result<Void, Error>) -> Void
