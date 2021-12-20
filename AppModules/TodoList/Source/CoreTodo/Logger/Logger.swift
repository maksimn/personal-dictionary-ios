//
//  Logger.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 21.06.2021.
//

protocol Logger {

    func networkRequestStart(_ type: String)

    func networkRequestSuccess(_ type: String)

    func log(error: Error)
}
