//
//  CoreWordListRepository.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.10.2021.
//

import CoreData
import CoreModule
import RxSwift

struct CoreWordListRepositoryArgs {

    let persistentContainerName: String
}

final class CoreWordListRepository: WordListRepository {

    private var mainContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    private lazy var persistentContainer: NSPersistentContainer = {
        let bundle = Bundle(for: type(of: self))

        guard let modelURL = bundle.url(forResource: args.persistentContainerName, withExtension: "momd"),
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

    init(args: CoreWordListRepositoryArgs, langRepository: LangRepository, logger: Logger) {
        self.args = args
        self.langRepository = langRepository
        self.logger = logger
    }

    var wordList: [WordItem] {
        let fetchRequest: NSFetchRequest<WordItemMO> = WordItemMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor.init(key: "createdAt", ascending: false)

        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            let wordItemMOList = try mainContext.fetch(fetchRequest)

            return wordItemMOList.compactMap { $0.convertToWordItem(with: langRepository) }
        } catch {
            logger.log(error: error)
            return []
        }
    }

    func add(_ wordItem: WordItem) -> Completable {
        return Completable.create { [weak self] completable in
            let backgroundContext = self?.persistentContainer.newBackgroundContext()

            backgroundContext?.perform { [weak self] in
                let wordItemMO = WordItemMO(entity: WordItemMO.entity(), insertInto: backgroundContext)

                wordItemMO.setData(from: wordItem)

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

                        wordItemMO.setData(from: wordItem)
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
}
