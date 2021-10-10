//
//  CoreWordListRepository.swift
//  PersonalDictionary
//
//  Created by Maxim Ivanov on 07.10.2021.
//

import Foundation
import CoreData

struct CoreWordListRepositoryArgs {

    let persistentContainerName: String
}

final class CoreWordListRepository: WordListRepository {

    private var mainContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: args.persistentContainerName)
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
        let sortDescriptor = NSSortDescriptor.init(key: "createdAt", ascending: true)

        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            let wordItemMOList = try mainContext.fetch(fetchRequest)

            return wordItemMOList.compactMap { $0.convertToWordItem(with: langRepository) }
        } catch {
            logger.log(error: error)
            return []
        }
    }

    func add(_ wordItem: WordItem, completion: ((Error?) -> Void)?) {
        let backgroundContext = persistentContainer.newBackgroundContext()

        backgroundContext.perform { [weak self] in
            let wordItemMO = WordItemMO(entity: WordItemMO.entity(), insertInto: backgroundContext)

            wordItemMO.setData(from: wordItem)

            do {
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion?(nil)
                }
            } catch {
                self?.logger.log(error: error)
                DispatchQueue.main.async {
                    completion?(error)
                }
            }
        }
    }

    func update(_ wordItem: WordItem, completion: ((Error?) -> Void)?) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        let predicate = NSPredicate.init(format: "id = '\(wordItem.id.raw)'")
        let fetchRequest: NSFetchRequest<WordItemMO> = WordItemMO.fetchRequest()

        fetchRequest.predicate = predicate

        backgroundContext.perform { [weak self] in
            do {
                let array = try backgroundContext.fetch(fetchRequest)

                if array.count > 0 {
                    let wordItemMO = array[0]

                    wordItemMO.setData(from: wordItem)
                }
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion?(nil)
                }
            } catch {
                self?.logger.log(error: error)
                DispatchQueue.main.async {
                    completion?(error)
                }
            }
        }
    }

    func remove(with wordItemId: WordItem.Id, completion: ((Error?) -> Void)?) {
        let backgroundContext = persistentContainer.newBackgroundContext()
        let predicate = NSPredicate.init(format: "id = '\(wordItemId.raw)'")
        let fetchRequest: NSFetchRequest<WordItemMO> = WordItemMO.fetchRequest()

        fetchRequest.predicate = predicate

        backgroundContext.perform { [weak self] in
            do {
                let array = try backgroundContext.fetch(fetchRequest)

                if array.count > 0 {
                    let itemMO = array[0]

                    backgroundContext.delete(itemMO)
                }
                try backgroundContext.save()
                DispatchQueue.main.async {
                    completion?(nil)
                }
            } catch {
                self?.logger.log(error: error)
                DispatchQueue.main.async {
                    completion?(error)
                }
            }
        }
    }
}
