//
//  JsonCoderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import RxSwift

public final class JSONCoderImpl: JsonCoder {

    public init() { }

    public func parseFromJson<T: Decodable>(_ data: Data) -> Single<T> {
        Single<T>.create { observer in
            do {
                let typedObject = try JSONDecoder().decode(T.self, from: data)

                observer(.success(typedObject))
            } catch {
                observer(.failure(error))
            }
            return Disposables.create { }
        }
    }

    public func convertToJson<T: Encodable>(_ object: T) -> Single<Data> {
        Single<Data>.create { observer in
            do {
                let data = try JSONEncoder().encode(object)

                observer(.success(data))
            } catch {
                observer(.failure(error))
            }
            return Disposables.create { }
        }
    }
}
