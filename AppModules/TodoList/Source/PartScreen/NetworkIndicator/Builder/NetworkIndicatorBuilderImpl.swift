//
//  NetwordIndicatorBuilderImpl.swift
//  SuperList
//
//  Created by Maxim Ivanov on 01.01.2022.
//

final class NetworkIndicatorBuilderImpl: NetworkIndicatorBuilder {

    private let service: TodoListService?

    init(service: TodoListService?) {
        self.service = service
    }

    func build() -> NetworkIndicatorVIPER {
        NetworkIndicatorVIPERImpl(service: service)
    }
}
