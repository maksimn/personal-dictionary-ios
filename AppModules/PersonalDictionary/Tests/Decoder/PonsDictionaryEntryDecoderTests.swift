//
//  PonsDictionaryEntryDecoderTests.swift
//  PersonalDictionaryTests
//
//  Created by Maksim Ivanov on 18.10.2023.
//

import CoreModule
import XCTest
@testable import PersonalDictionary

// swiftlint:disable type_body_length
final class PonsDictionaryEntryDecoderTests: XCTestCase {

    func test_stripOutTags__soonENITtranslationSourceOne__removesTag() throws {
        let result = PonsDictionaryEntryDecoder.stripOutTags(from: "<strong class=\"headword\">soon</strong>")

        XCTAssertEqual(result, "soon")
    }

    func test_stripOutTags__soonENITtranslationSourceFour__removesTag() throws {
        let result = PonsDictionaryEntryDecoder.stripOutTags(
            from: "<span class=\"example\">as <strong class=\"tilde\">soon</strong> as possible</span>")

        XCTAssertEqual(result, "as soon as possible")
    }

    func test_parseTarget__soonENIT__removesTag() throws {
        let result = PonsDictionaryEntryDecoder.stripOutTags(from: "il più presto possibile")

        XCTAssertEqual(result, "il più presto possibile")
    }

    // swiftlint:disable function_body_length line_length
    func test_decode__soonENITdata__correctResult() throws {
        // Arrange
        let soonENITdata =
"""
[
  {
    "lang": "en",
    "hits": [
      {
        "type": "entry",
        "opendict": false,
        "roms": [
          {
            "headword": "soon",
            "headword_full": "soon <span class=\\"phonetics\\">[su:n]</span> <span class=\\"wordclass\\"><acronym title=\\"adverb\\">ADV</acronym></span>",
            "wordclass": "adverb",
            "arabs": [
              {
                "header": "",
                "translations": [
                  {
                    "source": "<strong class=\\"headword\\">soon</strong>",
                    "target": "presto"
                  },
                  {
                    "source": "<span class=\\"example\\">as <strong class=\\"tilde\\">soon</strong> as possible</span>",
                    "target": "il più presto possibile"
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
  }
]
"""
        let decoder = PonsDictionaryEntryDecoder()

        // Act
        let result = try decoder.decode(Data(soonENITdata.utf8))

        // Assert
        XCTAssertEqual(
            result,
            DictionaryEntry([
                DictionaryEntryItem(
                    title: "soon",
                    subtitle: LocalizableStringKey("LS_ADVERB", bundle: Bundle.module),
                    subitems: [
                        DictionaryEntrySubitem(translation: "presto", example: nil),
                        DictionaryEntrySubitem(
                            translation: "il più presto possibile",
                            example: "as soon as possible"
                        )
                    ])
            ])
        )
    }

    // swiftlint:disable function_body_length line_length
    func test_decode__listenENITdata__correctResult() throws {
        // Arrange
        let listenENITdata =
"""
[
  {
    "lang": "en",
    "hits": [
      {
        "type": "entry",
        "opendict": false,
        "roms": [
          {
            "headword": "listen",
            "headword_full": "listen <span class=\\"phonetics\\">[ˈlɪ<span class=\\"separator\\">·</span>sən]</span> <span class=\\"wordclass\\"><acronym title=\\"noun\\">N</acronym></span> <span class=\\"style\\"><acronym title=\\"informal\\">inf</acronym></span>",
            "wordclass": "noun",
            "arabs": [
              {
                "header": "",
                "translations": [
                  {
                    "source": "<span class=\\"example\\">to have a <strong class=\\"tilde\\">listen</strong> (to <acronym title=\\"something\\">sth</acronym>)</span> <span class=\\"style\\"><acronym title=\\"informal\\">inf</acronym></span>",
                    "target": "ascoltare (<acronym title=\\"qualcosa\\">qc</acronym>)"
                  }
                ]
              }
            ]
          },
          {
            "headword": "listen",
            "headword_full": "listen <span class=\\"phonetics\\">[ˈlɪ<span class=\\"separator\\">·</span>sən]</span> <span class=\\"wordclass\\"><acronym title=\\"verb\\">VB</acronym></span> <span class=\\"verbclass\\"><acronym title=\\"intransitive verb\\">intr</acronym></span>",
            "wordclass": "intransitive verb",
            "arabs": [
              {
                "header": "1. listen <span class=\\"sense\\">(hear)</span>:",
                "translations": [
                  {
                    "source": "<strong class=\\"headword\\">listen</strong>",
                    "target": "ascoltare"
                  }
                ]
              }
            ]
          }
        ]
      },
      {
        "type": "entry",
        "opendict": true,
        "roms": [
          {
            "headword": "listen",
            "headword_full": "listen <span class=\\"wordclass\\"><acronym title=\\"verb\\">VB</acronym></span>",
            "wordclass": "verb",
            "arabs": [
              {
                "header": "",
                "translations": [
                  {
                    "source": "to <strong class=\\"tilde\\">listen</strong> out for <acronym title=\\"something\\">sth</acronym> <span class=\\"sense\\">(try to hear)</span> <span class=\\"style\\"><acronym title=\\"informal\\">inf</acronym></span>",
                    "target": "ascoltare con attenzione per cercare di sentire un suono atteso"
                  }
                ]
              }
            ]
          }
        ]
      },
      {
        "type": "entry",
        "opendict": false,
        "roms": [
          {
            "headword": "listen in",
            "headword_full": "listen in <span class=\\"wordclass\\"><acronym title=\\"verb\\">VB</acronym></span> <span class=\\"verbclass\\"><acronym title=\\"intransitive verb\\">intr</acronym></span>",
            "wordclass": "intransitive verb",
            "arabs": [
              {
                "header": "",
                "translations": [{
                    "source": "<span class=\\"example\\">to <strong class=\\"tilde\\">listen in</strong> on <acronym title=\\"something\\">sth</acronym></span>",
                    "target": "origliare <acronym title=\\"qualcosa\\">qc</acronym>"
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
  }
]
"""
        let decoder = PonsDictionaryEntryDecoder()

        // Act
        let result = try decoder.decode(Data(listenENITdata.utf8))

        // Assert
        let expected = DictionaryEntry([
            DictionaryEntryItem(
                title: "listen",
                subtitle: LocalizableStringKey("LS_NOUN", bundle: Bundle.module),
                subitems: [
                    DictionaryEntrySubitem(
                        translation: "ascoltare (qc)",
                        example: "to have a listen (to sth)"
                    )
                ]
            ),
            DictionaryEntryItem(
                title: "listen",
                subtitle: LocalizableStringKey("LS_VERB", bundle: Bundle.module),
                subitems: [
                    DictionaryEntrySubitem(
                        translation: "ascoltare",
                        example: nil
                    ),
                    DictionaryEntrySubitem(
                        translation: "ascoltare con attenzione per cercare di sentire un suono atteso",
                        example: "to listen out for sth (try to hear)"
                    )
                ]
            ),
            DictionaryEntryItem(
                title: "listen in",
                subtitle: LocalizableStringKey("LS_VERB", bundle: Bundle.module),
                subitems: [
                    DictionaryEntrySubitem(
                        translation: "origliare qc",
                        example: "to listen in on sth"
                    )
                ]
            )
        ])

        XCTAssertEqual(result, expected)
    }

    // swiftlint:disable function_body_length line_length
    func test_decode__pitchENRUdata__correctResult() throws {
        let rawJSON =
"""
[
  {
    "lang": "en",
    "hits": [
      {
        "type": "entry",
        "opendict": false,
        "roms": [
          {
            "headword": "pitch",
            "headword_full": "pitch<sup>1</sup> <span class=\\"phonetics\\">[pɪtʃ]</span> <span class=\\"wordclass\\"><acronym title=\\"noun\\">N</acronym></span>",
            "wordclass": "noun",
            "arabs": [
              {
                "header": "1. pitch <span class=\\"region\\"><acronym title=\\"British English\\" class=\\"Brit\\">Brit</acronym>, <acronym title=\\"Australian English\\" class=\\"Aus\\">Aus</acronym></span> <span class=\\"topic\\">sports</span> <span class=\\"sense\\">(playing field)</span>:",
                "translations": [
                  {
                    "source": "<strong class=\\"headword\\">pitch</strong>",
                    "target": "площа́дка <span class=\\"genus\\"><acronym title=\\"feminine\\">f</acronym></span>"
                  },
                  {
                    "source": "<span class=\\"example\\">football <strong class=\\"tilde\\">pitch</strong></span>",
                    "target": "футбо́льное по́ле <span class=\\"genus\\"><acronym title=\\"neuter\\">nt</acronym></span>"
                  }
                ]
              }
            ]
          }
        ]
      },
      {
        "type": "entry",
        "opendict": false,
        "roms": [
          {
            "headword": "pitch-dark",
            "headword_full": "pitch-dark ",
            "arabs": [
              {
                "header": "pitch-dark <span class=\\"indirect_reference_OTHER\\">→ pitch-black</span>",
                "translations": [
                  {
                    "source": "",
                    "target": ""
                  }
                ]
              }
            ]
          }
        ]
      }
    ]
  }
]
"""
        let decoder = PonsDictionaryEntryDecoder()

        // Act
        let result = try decoder.decode(Data(rawJSON.utf8))

        // Assert
        let expected = [
            DictionaryEntryItem(
                title: "pitch",
                subtitle: LocalizableStringKey("LS_NOUN", bundle: Bundle.module),
                subitems: [
                    DictionaryEntrySubitem(
                        translation: "площа́дка",
                        context: [
                            LocalizableStringKey("LS_BR_ENG", bundle: Bundle.module),
                            LocalizableStringKey("LS_AUS_ENG", bundle: Bundle.module)
                        ],
                        example: nil
                    ),
                    DictionaryEntrySubitem(
                        translation: "футбо́льное по́ле",
                        context: [
                            LocalizableStringKey("LS_BR_ENG", bundle: Bundle.module),
                            LocalizableStringKey("LS_AUS_ENG", bundle: Bundle.module)
                        ],
                        example: "football pitch"
                    )
                ]
            )
        ]

        XCTAssertEqual(result, expected)
    }
}
