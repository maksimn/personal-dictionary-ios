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
struct CoreWordListRepositoryArgs {

    /// Бандл для работы с ресурсами модуля "Personal Dictionary"
    let bundle: Bundle

    /// Название Persistent Container'a
    let persistentContainerName: String
}

/// Реализация хранилища слов личного словаря на основе фреймворка Core Data.
final class CoreWordListRepository: WordListRepository {

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
                self.logger.log(error: error)
            }
        })
        return container
    }()

    private let langRepository: LangRepository
    private let logger: Logger
    private let args: CoreWordListRepositoryArgs

    /// Инициализатор.
    /// - Parameters:
    ///  - args: аргументы хранилища списка слов.
    ///  - langRepository: хранилище данных о языках.
    ///  - logger: логгер.
    init(args: CoreWordListRepositoryArgs, langRepository: LangRepository, logger: Logger) {
        self.args = args
        self.langRepository = langRepository
        self.logger = logger
    }

    /// Список слов из личного словаря.
    var wordList: [WordItem] {
        filter(withPredicate: nil)
    }

    var favoriteWordList: [WordItem] {
        filter(withPredicate: NSPredicate(format: "isFavorite == true"))
    }

    /// Добавить слово в хранилище личного словаря
    /// - Parameters:
    ///  - wordItem: слово для добавления.
    /// - Returns: Rx completable для обработки завершения операции добавления слова в хранилище.
    func add(_ wordItem: WordItem) -> Completable {
        return Completable.create { [weak self] completable in
            let backgroundContext = self?.persistentContainer.newBackgroundContext()

            backgroundContext?.perform { [weak self] in
                let wordItemMO = WordItemMO(entity: WordItemMO.entity(), insertInto: backgroundContext)

                wordItemMO.set(wordItem)

                do {
                    try backgroundContext?.save()
                    DispatchQueue.main.async {
                        completable(.completed)
                    }
                } catch {
                    self?.logger.log(error: error)
                    DispatchQueue.main.async {
                        completable(.error(error))
                    }
                }
            }

            return Disposables.create {}
        }
    }

    /// Обновить слово в хранилище личного словаря
    /// - Parameters:
    ///  - wordItem: обновленное слово.
    /// - Returns: Rx completable для обработки завершения операции обновления слова в хранилище.
    func update(_ wordItem: WordItem) -> Completable {
        return Completable.create { [weak self] completable in
            let backgroundContext = self?.persistentContainer.newBackgroundContext()
            let predicate = NSPredicate.init(format: "id = '\(wordItem.id.raw)'")
            let fetchRequest: NSFetchRequest<WordItemMO> = WordItemMO.fetchRequest()

            fetchRequest.predicate = predicate

            backgroundContext?.perform { [weak self] in
                do {
                    let array = try backgroundContext?.fetch(fetchRequest) ?? []

                    if array.count > 0 {
                        let wordItemMO = array[0]

                        wordItemMO.set(wordItem)
                    }
                    try backgroundContext?.save()
                    DispatchQueue.main.async {
                        completable(.completed)
                    }
                } catch {
                    self?.logger.log(error: error)
                    DispatchQueue.main.async {
                        completable(.error(error))
                    }
                }
            }
            return Disposables.create {}
        }
    }

    /// Удалить слово из хранилища личного словаря
    /// - Parameters:
    ///  - wordItemId: идентификатор слова для его удаления из хранилища.
    /// - Returns: Rx completable для обработки завершения операции удаления слова из хранилища.
    func remove(with wordItemId: WordItem.Id) -> Completable {
        return Completable.create { [weak self] completable in
            let backgroundContext = self?.persistentContainer.newBackgroundContext()
            let predicate = NSPredicate.init(format: "id = '\(wordItemId.raw)'")
            let fetchRequest: NSFetchRequest<WordItemMO> = WordItemMO.fetchRequest()

            fetchRequest.predicate = predicate

            backgroundContext?.perform { [weak self] in
                do {
                    let array = try backgroundContext?.fetch(fetchRequest) ?? []

                    if array.count > 0 {
                        let itemMO = array[0]

                        backgroundContext?.delete(itemMO)
                    }
                    try backgroundContext?.save()
                    DispatchQueue.main.async {
                        completable(.completed)
                    }
                } catch {
                    self?.logger.log(error: error)
                    DispatchQueue.main.async {
                        completable(.error(error))
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
    func findWords(contain string: String) -> [WordItem] {
        filter(withPredicate: NSPredicate(format: "text contains[cd] \"\(string)\""))
    }

    /// Найти слова, перевод которых содержит строку.
    /// - Parameters:
    ///  - string: строка для поиска.
    /// - Массив найденных слов.
    func findWords(whereTranslationContains string: String) -> [WordItem] {
        filter(withPredicate: NSPredicate(format: "translation contains[cd] \"\(string)\""))
    }

    /// Delete all objects of WordItem entity.
    func removeAllWordItems() throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WordItemMO")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: mainContext)
    }

    private func filter(withPredicate predicate: NSPredicate?) -> [WordItem] {
        let fetchRequest: NSFetchRequest<WordItemMO> = WordItemMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor.init(key: "createdAt", ascending: false)

        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            let wordItemMOList = try mainContext.fetch(fetchRequest)

            return wordItemMOList.compactMap { $0.convert(using: langRepository) }
        } catch {
            logger.log(error: error)
            return []
        }
    }
}
