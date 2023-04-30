//
//  Router.swift
//  CoreModule
//
//  Created by Maxim Ivanov on 16.12.2021.
//

public protocol Router {

    func navigate()
}

public protocol ParametrizedRouter {

    associatedtype Parameter

    func navigate(_ parameter: Parameter)
}
