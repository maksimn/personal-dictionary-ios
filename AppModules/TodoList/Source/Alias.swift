//
//  Alias.swift
//  ReTodoList
//
//  Created by Maksim Ivanov on 20.01.2023.
//

import Foundation

typealias DataCallback = (Result<Data, Error>) -> Void
typealias Callback<T> = (Result<T, Error>) -> Void

typealias TodoListCallback = (Result<[Todo], Error>) -> Void
typealias VoidCallback = (Result<Void, Error>) -> Void

typealias TodoListDTOCallback = (Result<[TodoDTO], Error>) -> Void
typealias TodoDTOCallback = (Result<TodoDTO, Error>) -> Void
