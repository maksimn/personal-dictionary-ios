//
//  PonsTranslationService.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 09.10.2021.
//

import CoreModule
import Foundation

/// Service for fetching word translations from the PONS Online Dictionary API.
final class PonsDictionaryService: DictionaryService {

    private let secret: String
    private let httpClient: HttpClient

    private let apiUrl = "https://api.pons.com/v1/dictionary"

    /// - Parameters:
    ///  - secret: secret for accessing the online PONS API.
    ///  - httpClient: base service for network requests over the HTTP protocol.
    init(secret: String, httpClient: HttpClient) {
        self.secret = secret
        self.httpClient = httpClient
    }

    func fetchDictionaryEntry(for word: Word) async throws -> WordData {
        var query = URLComponents()

        query.queryItems = [
            URLQueryItem(name: "q", value: word.text),
            URLQueryItem(name: "l", value: lQueryParam(for: word))
        ]

        let http = Http(
            urlString: apiUrl + (query.string ?? ""),
            headers: ["X-Secret": secret]
        )

        let httpResponse = try await httpClient.send(http)

        guard httpResponse.response.statusCode == 200 else {
            throw Fail.emptyDataFor(word)
        }

        return WordData(word: word, entry: httpResponse.data)
    }

    private func lQueryParam(for word: Word) -> String {
        let sourceLang = word.sourceLang.shortNameKey.raw
        let targetLang = word.targetLang.shortNameKey.raw
        guard let sourceLangIndex = sourceLang.firstIndex(of: "_") else { return "" }
        guard let targetLangIndex = targetLang.firstIndex(of: "_") else { return "" }
        let sourceLangParam = sourceLang.suffix(from: sourceLang.index(sourceLangIndex, offsetBy: 1)).lowercased()
        let targetLangParam = targetLang.suffix(from: targetLang.index(targetLangIndex, offsetBy: 1)).lowercased()

        return sourceLangParam + targetLangParam
    }

    enum Fail: Error {
        case emptyDataFor(Word)
    }
}
