//
//  Config.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 10.10.2021.
//

/// Configuration parameters of the "Personal Dictionary" application.
struct AppConfig {

    /// Language data in the application
    let langData: LangData

    /// Key for requests to the Pons API for word translation
    let ponsApiSecret: String

    /// Daily push notification time
    let everydayPNTime: EverydayPNTime

    /// Daily push notification time
    struct EverydayPNTime {

        /// Hours
        let hours: Int

        /// Minutes
        let minutes: Int
    }
}
