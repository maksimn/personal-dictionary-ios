//
//  JsonCoderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import Foundation

final class JSONCoderImpl: JsonCoder {

    func encodeAsync<T: Encodable>(_ object: T,
                                   _ completion: @escaping (Result<Data, Error>) -> Void) {
        if Thread.isMainThread {
            DispatchQueue.global(qos: .default).async { [weak self] in
                self?.encodeAndReturnToMainThread(object, completion)
            }
        } else {
            encodeAndReturnToMainThread(object, completion)
        }
    }

    func decodeAsync<T: Decodable>(_ data: Data,
                                   _ completion: @escaping (Result<T, Error>) -> Void) {
        if Thread.isMainThread {
            DispatchQueue.global(qos: .default).async { [weak self] in
                self?.decodeAndReturnToMainThread(data, completion)
            }
        } else {
            decodeAndReturnToMainThread(data, completion)
        }
    }

    func encodeAndReturnToMainThread<T: Encodable>(_ object: T,
                                                   _ completion: @escaping (Result<Data, Error>) -> Void) {
        do {
            let data = try JSONEncoder().encode(object)

            DispatchQueue.main.async {
                completion(.success(data))
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }

    func decodeAndReturnToMainThread<T: Decodable>(_ data: Data,
                                                   _ completion: @escaping (Result<T, Error>) -> Void) {
        do {
            let typedResponse = try JSONDecoder().decode(T.self, from: data)

            DispatchQueue.main.async {
                completion(.success(typedResponse))
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
}
