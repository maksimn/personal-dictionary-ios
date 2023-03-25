//
//  CoreRouter.swift
//  CoreModule
//
//  Created by Maxim Ivanov on 16.12.2021.
//

func isDevelopment() -> Bool {
    #if DEBUG
    return true
    #else
    return false
    #endif
}
