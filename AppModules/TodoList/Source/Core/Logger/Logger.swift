//
//  Logger.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.10.2021.
//

protocol Logger {

    func log(message: String)

    func log(error: Error)
}
