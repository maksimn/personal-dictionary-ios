//
//  WordListBuilderImpl.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.11.2021.
//

final class FavoriteWordListBuilderImpl: FavoriteWordListBuilder {

    private let appConfig: AppConfig

    private let bundle: Bundle

    init(appConfig: AppConfig,
         bundle: Bundle) {
        self.appConfig = appConfig
        self.bundle = bundle
    }

    func build() -> FavoriteWordListGraph {
        FavoriteWordListGraphImpl(
            wordListBuilder: WordListBuilderImpl(
                shouldAnimateWhenAppear: false,
                appConfig: appConfig,
                bundle: bundle
            ),
            favoriteWordListFetcher: CoreWordListRepository(appConfig: appConfig, bundle: bundle),
            wordItemStream: WordItemStreamImpl.instance
        )
    }
}
