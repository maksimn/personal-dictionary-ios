//
//  CoreWordListRepository.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.10.2021.
//

import CoreData
import CoreModule
import RxSwift

/// Аргументы хранилища слов личного словаря на основе фреймворка Core Data.
struct WordListRepositoryArgs {

    /// Бандл для работы с ресурсами модуля "Personal Dictionary"
    let bundle: Bundle

    /// Название Persistent Container'a
    let persistentContainerName: String
}

/// Реализация хранилища слов личного словаря на основе фреймворка Core Data.
final class WordListRepositoryImpl: WordListRepository {

    private var mainContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    private lazy var persistentContainer: NSPersistentContainer = {
        guard let modelURL = args.bundle.url(forResource: args.persistentContainerName, withExtension: "momd"),
              let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            return NSPersistentContainer()
        }

        let container = NSPersistentContainer(name: args.persistentContainerName,
                                              managedObjectModel: managedObjectModel)

        container.loadPersistentStores(completionHandler: { (_, error) in
            container.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy

            if let error = error {
                self.logger.logError(error)
            }
        })
        return container
    }()

    private let langRepository: LangRepository
    private let logger: Logger
    private let args: WordListRepositoryArgs

    /// Инициализатор.
    /// - Parameters:
    ///  - args: аргументы хранилища списка слов.
    ///  - langRepository: хранилище данных о языках.
    ///  - logger: логгер.
    init(args: WordListRepositoryArgs,
         langRepository: LangRepository,
         logger: Logger) {
        self.args = args
        self.langRepository = langRepository
        self.logger = logger
    }

    convenience init(langData: LangData, bundle: Bundle) {
        self.init(
            args: WordListRepositoryArgs(
                bundle: bundle,
                persistentContainerName: "StorageModel"
            ),
            langRepository: LangRepositoryImpl(
                userDefaults: UserDefaults.standard,
                data: langData
            ),
            logger: LoggerImpl(category: "PersonalDictionary.WordListRepository")
        )
    }

    /// Список слов из личного словаря.
    var wordList: [Word] {
        filter(withPredicate: nil)
    }

    var favoriteWordList: [Word] {
        filter(withPredicate: NSPredicate(format: "isFavorite == true"))
    }

    func add(_ word: Word) -> Single<Word> {
        .create { [weak self] single in
            let backgroundContext = self?.persistentContainer.newBackgroundContext()

            backgroundContext?.perform {
                let wordMO = WordMO(entity: WordMO.entity(), insertInto: backgroundContext)

                wordMO.set(word)

                do {
                    try backgroundContext?.save()
                    DispatchQueue.main.async {
                        single(.success(word))
                    }
                } catch {
                    DispatchQueue.main.async {
                        single(.error(error))
                    }
                }
            }

            return Disposables.create {}
        }
    }

    func update(_ word: Word) -> Single<Word> {
        .create { [weak self] single in
            let backgroundContext = self?.persistentContainer.newBackgroundContext()
            let predicate = NSPredicate.init(format: "id = '\(word.id.raw)'")
            let fetchRequest: NSFetchRequest<WordMO> = WordMO.fetchRequest()

            fetchRequest.predicate = predicate

            backgroundContext?.perform {
                do {
                    let array = try backgroundContext?.fetch(fetchRequest) ?? []

                    if array.count > 0 {
                        let wordMO = array[0]

                        wordMO.set(word)
                    }
                    try backgroundContext?.save()
                    DispatchQueue.main.async {
                        single(.success(word))
                    }
                } catch {
                    DispatchQueue.main.async {
                        single(.error(error))
                    }
                }
            }
            return Disposables.create {}
        }
    }

    func remove(_ word: Word) -> Single<Word> {
        .create { [weak self] single in
            let backgroundContext = self?.persistentContainer.newBackgroundContext()
            let predicate = NSPredicate.init(format: "id = '\(word.id.raw)'")
            let fetchRequest: NSFetchRequest<WordMO> = WordMO.fetchRequest()

            fetchRequest.predicate = predicate

            backgroundContext?.perform {
                do {
                    let array = try backgroundContext?.fetch(fetchRequest) ?? []

                    if array.count > 0 {
                        let wordMO = array[0]

                        backgroundContext?.delete(wordMO)
                    }
                    try backgroundContext?.save()
                    DispatchQueue.main.async {
                        single(.success(word))
                    }
                } catch {
                    DispatchQueue.main.async {
                        single(.error(error))
                    }
                }
            }
            return Disposables.create {}
        }
    }

    /// Найти слова, содержащие строку.
    /// - Parameters:
    ///  - string: строка для поиска.
    /// - Массив найденных слов.
    func findWords(contain string: String) -> [Word] {
        filter(withPredicate: NSPredicate(format: "text contains[cd] \"\(string)\""))
    }

    /// Найти слова, перевод которых содержит строку.
    /// - Parameters:
    ///  - string: строка для поиска.
    /// - Массив найденных слов.
    func findWords(whereTranslationContains string: String) -> [Word] {
        filter(withPredicate: NSPredicate(format: "translation contains[cd] \"\(string)\""))
    }

    /// Delete all objects of WordItem entity.
    func removeAllWords() throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WordMO")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: mainContext)
    }

    private func filter(withPredicate predicate: NSPredicate?) -> [Word] {
        let fetchRequest: NSFetchRequest<WordMO> = WordMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor.init(key: "createdAt", ascending: false)

        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            let wordMOList = try mainContext.fetch(fetchRequest)

            return wordMOList.compactMap { $0.convert(using: langRepository) }
        } catch {
            logger.log("\(error)")
            return []
        }
    }
}
