//
//  Sync+DI.swift
//  TodoList
//
//  Created by Maksim Ivanov on 10.07.2023.
//

import SharedFeature
import UIKit

struct SyncConfig {
    let token: String
    let minDelay: Double
}

extension Sync {
    init(config: SyncConfig) {
        let featureName = "TodoList.Sync"

        self.init(
            params: SyncParams(minDelay: config.minDelay, maxDelay: 120, factor: 1.5, jitter: 0.05),
            dirtyStateCache: DirtyStateCacheImp(persistentContainer: persistentContainer(featureName)),
            syncService: SyncServiceImp(token: config.token),
            randomNumber: { Double.random(in: -1.0...1.0) },
            sharedMessageSender: SharedMessageStreamImpl.instance,
            syncErrorMessage: Bundle.module.moduleLocalizedString("LS_SYNC_FAILED")
        )
    }
}
