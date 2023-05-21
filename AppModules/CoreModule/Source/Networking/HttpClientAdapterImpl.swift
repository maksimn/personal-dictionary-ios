//
//  HttpClientAdapter.swift
//  CoreModule
//
//  Created by Maxim Ivanov on 21.05.2023.
//

import Combine

public final class HttpClientAdapterImpl: HttpClientAdapter {

    private let httpClient: HttpClient

    private var cancellables: Set<AnyCancellable> = []

    public init(httpClient: HttpClient = LoggableHttpClient(logger: LoggerImpl(category: "HTTP"))) {
        self.httpClient = httpClient
    }

    public func send(_ http: Http) async throws -> HttpResponseResult {
        try await withCheckedThrowingContinuation { continuation in
            httpClient.send(http)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        case .finished:
                            break
                        }
                    },
                    receiveValue: { httpResponse in
                        continuation.resume(
                            returning: HttpResponseResult(response: httpResponse.response, data: httpResponse.data)
                        )
                    }
                ).store(in: &self.cancellables)
        }
    }
}
