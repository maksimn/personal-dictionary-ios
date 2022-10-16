//
//  WordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

final class FavoriteWordListBuilderImpl: FavoriteWordListBuilder {

    private let appConfig: AppConfig

    init(appConfig: AppConfig) {
        self.appConfig = appConfig
    }

    func build() -> FavoriteWordListGraph {
        FavoriteWordListGraphImpl(
            wordListBuilder: WordListBuilderImpl(
                shouldAnimateWhenAppear: false,
                appConfig: appConfig
            ),
            favoriteWordListFetcher: CoreWordListRepository(appConfig: appConfig),
            wordItemStream: WordItemStreamImpl.instance
        )
    }
}
