//
//  WordStreamLog.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 12.01.2025.
//

import CoreModule

struct NewWordStreamLog: NewWordStream, NewWordSender {

    let logger: Logger
    let modelStream: NewWordStream & NewWordSender

    private static let modelStreamName = "NEW WORD"

    var newWord: AsyncStream<Word> {
        AsyncStream { continuation in
            Task {
                for await word in modelStream.newWord {
                    logger.logReceiving(word, fromModelStream: Self.modelStreamName)
                    continuation.yield(word)
                }
                continuation.finish()
            }
        }
    }

    func sendNewWord(_ word: Word) {
        logger.logSending(word, toModelStream: Self.modelStreamName)

        modelStream.sendNewWord(word)
    }
}

struct UpdatedWordStreamLog: UpdatedWordStream, UpdatedWordSender {

    let logger: Logger
    let modelStream: UpdatedWordStream & UpdatedWordSender

    private static let modelStreamName = "UPDATED WORD"

    var updatedWord: AsyncStream<UpdatedWord> {
        AsyncStream { continuation in
            Task {
                for await updatedWord in modelStream.updatedWord {
                    logger.logReceiving(updatedWord, fromModelStream: Self.modelStreamName)
                    continuation.yield(updatedWord)
                }
                continuation.finish()
            }
        }
    }

    func sendUpdatedWord(_ updatedWord: UpdatedWord) {
        logger.logSending(updatedWord, toModelStream: Self.modelStreamName)

        modelStream.sendUpdatedWord(updatedWord)
    }
}

struct RemovedWordStreamLog: RemovedWordStream, RemovedWordSender {

    let logger: Logger
    let modelStream: RemovedWordStream & RemovedWordSender

    private static let modelStreamName = "REMOVED WORD"

    var removedWord: AsyncStream<Word> {
        AsyncStream { continuation in
            Task {
                for await word in modelStream.removedWord {
                    logger.logReceiving(word, fromModelStream: Self.modelStreamName)
                    continuation.yield(word)
                }
                continuation.finish()
            }
        }
    }

    func sendRemovedWord(_ word: Word) {
        logger.logSending(word, toModelStream: Self.modelStreamName)

        modelStream.sendRemovedWord(word)
    }
}
