//
//  JsonCoder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import Foundation

protocol JsonCoder {

    func encodeAsync<T: Encodable>(_ object: T,
                                   _ completion: @escaping (Result<Data, Error>) -> Void)

    func decodeAsync<T: Decodable>(_ data: Data,
                                   _ completion: @escaping (Result<T, Error>) -> Void)
}
