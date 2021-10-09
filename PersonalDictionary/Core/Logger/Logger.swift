//
//  Logger.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.10.2021.
//

protocol Logger {

    func networkRequestStart(_ requestName: String)

    func networkRequestSuccess(_ requestName: String)

    func networkRequestError(_ requestName: String)

    func log(error: Error)
}
