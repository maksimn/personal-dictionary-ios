//
//  TodoCoder.swift
//  CoreTodo
//
//  Created by Maxim Ivanov on 13.07.2021.
//

import Foundation

protocol JsonCoder {

    func encode<T: Encodable>(_ object: T, _ completion: @escaping DataCallback)

    func decode<T: Decodable>(_ data: Data, _ completion: @escaping Callback<T>)
}
