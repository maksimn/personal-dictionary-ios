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
                observer(.error(error))
            }
            return Disposables.create { }
        }
        .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default))
        .observeOn(MainScheduler.instance)
    }
}
