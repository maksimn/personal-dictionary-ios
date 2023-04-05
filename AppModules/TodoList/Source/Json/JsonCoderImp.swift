//
//  TodoCoder.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 26.06.2021.
//

import Foundation

class JsonCoderImp: JsonCoder {

    func encode<T: Encodable>(_ object: T, _ completion: @escaping DataCallback) {
        if Thread.isMainThread {
            DispatchQueue.global(qos: .default).async { [weak self] in
                self?.encodeAndReturnToMainThread(object, completion)
            }
        } else {
            encodeAndReturnToMainThread(object, completion)
        }
    }

    func decode<T: Decodable>(_ data: Data, _ completion: @escaping Callback<T>) {
        if Thread.isMainThread {
            DispatchQueue.global(qos: .default).async { [weak self] in
                self?.decodeAndReturnToMainThread(data, completion)
            }
        } else {
            decodeAndReturnToMainThread(data, completion)
        }
    }

    private func encodeAndReturnToMainThread<T: Encodable>(_ object: T,
                                                           _ completion: @escaping DataCallback) {
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

    private func decodeAndReturnToMainThread<T: Decodable>(_ data: Data,
                                                           _ completion: @escaping Callback<T>) {
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
