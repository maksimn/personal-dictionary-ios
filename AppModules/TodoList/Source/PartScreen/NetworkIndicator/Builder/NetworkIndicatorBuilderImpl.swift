//
//  NetwordIndicatorBuilderImpl.swift
//  SuperList
//
//  Created by Maxim Ivanov on 01.01.2022.
//

final class NetworkIndicatorBuilderImpl: NetworkIndicatorBuilder {

    private let httpRequestCounter: HttpRequestCounter?

    init(httpRequestCounter: HttpRequestCounter?) {
        self.httpRequestCounter = httpRequestCounter
    }

    func build() -> NetworkIndicatorVIPER {
        NetworkIndicatorVIPERImpl(httpRequestCounter: httpRequestCounter)
    }
}
