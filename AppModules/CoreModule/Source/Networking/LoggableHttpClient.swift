//
//  LoggableHttpClient.swift
//  CoreModule
//
//  Created by Maksim Ivanov on 06.05.2023.
//

public final class LoggableHttpClient: HttpClient {

    private let httpClient: HttpClient
    private let logger: Logger

    public init(httpClient: HttpClient = HttpClientImpl(), logger: Logger) {
        self.httpClient = httpClient
        self.logger = logger
    }

    public func send(_ http: Http) -> RxHttpResponse {
        logger.log("HTTP REQUEST START: \(http)", level: .info)

        if let body = http.body {
            logger.log("HTTP REQUEST BODY: \(body.asUTF8)", level: .info)
        }

        return httpClient.send(http)
            .handleEvents(
                receiveOutput: { httpResponse in
                    self.logger.log(
                        """
                        HTTP RESPONSE FETCHED
                        HTTPURLResponse: \(httpResponse.response)
                        HTTP_Response_Data: \(httpResponse.data.asUTF8)
                        """,
                        level: .info
                    )
                },
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        self.logger.log("HTTP REQUEST ERROR: \(error)", level: .error)

                    default:
                        break
                    }
                }
            )
            .eraseToAnyPublisher()
    }
}
