//
//  common.swift
//  PersonalDictionaryTests
//
//  Created by Maksim Ivanov on 24.02.2023.
//

import Foundation
@testable import PersonalDictionary

func removeRealmData() {
    runAsyncTaskBlocking {
        try await removeRealmDataAsync()
    }
}

func removeRealmDataAsync() async throws {
    try await deleteAll(WordDAO.self)
    try await deleteAll(DictionaryEntryDAO.self)
    try await deleteAll(WordTranslationIndexDAO.self)
}

func runAsyncTaskBlocking(_ asyncBlock: @escaping () async throws -> Void) {
    // 1. Create a semaphore with an initial count of 0
    let semaphore = DispatchSemaphore(value: 0)

    // 2. Spawn a detached task to avoid inheriting the MainActor context
    Task.detached(priority: .userInitiated) {
        // Simulate an asynchronous operation
        try? await asyncBlock() // 2 seconds

        // 3. Signal the semaphore to unlock the main thread
        semaphore.signal()
    }

    // 4. Block the current thread (Main Thread) until signaled
    semaphore.wait()
}
