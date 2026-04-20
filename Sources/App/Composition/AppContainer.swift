//
//  AppContainer.swift
//  Main
//
//  Created by Thiago Henrique on 20/04/26.
//

import Foundation

final class AppContainer {
    private(set) lazy var discoStore: DiscoStore = {
        (try? CoreDataDiscoStore()) as DiscoStore? ?? InMemoryDiscoStore(database: InMemoryDatabase.instance)
    }()

    private(set) lazy var discoProfileRepository: DiscoProfileRepository = {
        DiscoProfileRepositoryImpl(
            store: discoStore,
            fileManagerService: FileManagerServiceImpl()
        )
    }()
}
