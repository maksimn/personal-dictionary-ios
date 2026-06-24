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

    public func send(_ http: Http) async throws -> HttpResponseResult {
        logger.log("HTTP REQUEST START: \(http)", level: .info)

        if let body = http.body {
            logger.log("HTTP REQUEST BODY: \(body.asUTF8)", level: .info)
        }

        do {
            let result = try await httpClient.send(http)

            logger.log(
                """
                HTTP RESPONSE FETCHED
                HTTPURLResponse: \(result.response)
                HTTP_Response_Data: \(result.data.asUTF8)
                """,
                level: .info
            )

            return result
        } catch {
            logger.log("HTTP REQUEST ERROR: \(error)", level: .error)
            throw error
        }
    }
}
