//
//  JsonCoder.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import RxSwift

public protocol JsonCoder {

    func parseFromJson<T: Decodable>(_ data: Data) -> Single<T>
}
