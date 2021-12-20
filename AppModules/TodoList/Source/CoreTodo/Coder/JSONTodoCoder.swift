//
//  TodoCoder.swift
//  ToDoList
//
//  Created by Maxim Ivanov on 26.06.2021.
//

import Foundation

public class JSONTodoCoder: TodoCoder {

    public init() { }

    public func encodeAsync<T: Encodable>(_ requestData: T,
                                          _ completion: @escaping (Result<Data, Error>) -> Void) {
        if Thread.isMainThread {
            DispatchQueue.global(qos: .default).async { [weak self] in
                self?.encodeAndReturnToMainThread(requestData, completion)
            }
        } else {
            encodeAndReturnToMainThread(requestData, completion)
        }
    }

    public func decodeAsync<T: Decodable>(_ data: Data,
                                          _ completion: @escaping (Result<T, Error>) -> Void) {
        if Thread.isMainThread {
            DispatchQueue.global(qos: .default).async { [weak self] in
                self?.decodeAndReturnToMainThread(data, completion)
            }
        } else {
            decodeAndReturnToMainThread(data, completion)
        }
    }

    private func encodeAndReturnToMainThread<T: Encodable>(_ requestData: T,
                                                           _ completion: @escaping (Result<Data, Error>) -> Void) {
        do {
            let data = try JSONEncoder().encode(requestData)

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
