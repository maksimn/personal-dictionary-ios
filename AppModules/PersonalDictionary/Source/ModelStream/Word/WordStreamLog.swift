//
//  WordStreamLog.swift
//  PersonalDictionary
//
//  Created by Maksim Ivanov on 12.01.2025.
//

import CoreModule
import RxSwift

struct NewWordStreamLog: NewWordStream, NewWordSender {

    let logger: Logger
    let modelStream: NewWordStream & NewWordSender

    private static let modelStreamName = "NEW WORD"

    var newWord: Observable<Word> {
        modelStream.newWord.do(onNext: { (word: Word) in
            logger.logReceiving(word, fromModelStream: NewWordStreamLog.modelStreamName)
        })
    }

    func sendNewWord(_ word: Word) {
        logger.logSending(word, toModelStream: NewWordStreamLog.modelStreamName)

        modelStream.sendNewWord(word)
    }
}

struct UpdatedWordStreamLog: UpdatedWordStream, UpdatedWordSender {

    let logger: Logger
    let modelStream: UpdatedWordStream & UpdatedWordSender

    private static let modelStreamName = "UPDATED WORD"

    var updatedWord: Observable<UpdatedWord> {
        modelStream.updatedWord.do(onNext: { (updatedWord: UpdatedWord) in
            logger.logReceiving(updatedWord, fromModelStream: UpdatedWordStreamLog.modelStreamName)
        })
    }

    func sendUpdatedWord(_ updatedWord: UpdatedWord) {
        logger.logSending(updatedWord, toModelStream: UpdatedWordStreamLog.modelStreamName)

        modelStream.sendUpdatedWord(updatedWord)
    }
}

struct RemovedWordStreamLog: RemovedWordStream, RemovedWordSender {

    let logger: Logger
    let modelStream: RemovedWordStream & RemovedWordSender

    private static let modelStreamName = "REMOVED WORD"

    var removedWord: Observable<Word> {
        modelStream.removedWord.do(onNext: { (word: Word) in
            logger.logReceiving(word, fromModelStream: RemovedWordStreamLog.modelStreamName)
        })
    }

    func sendRemovedWord(_ word: Word) {
        logger.logSending(word, toModelStream: RemovedWordStreamLog.modelStreamName)

        modelStream.sendRemovedWord(word)
    }
}
