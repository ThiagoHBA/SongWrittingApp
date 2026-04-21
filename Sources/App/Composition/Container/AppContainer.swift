//
//  AppContainer.swift
//  Main
//
//  Created by Thiago Henrique on 20/04/26.
//

import Foundation

final class AppContainer {
    enum Storage {
        case persistent
        case inMemory(database: InMemoryDatabase = InMemoryDatabase())
    }

    private static let sharedFactory: () -> AppContainer = {
        let crashReporter = crashReporterFactory()
        do {
            return try AppContainer(storage: .persistent, crashReporter: crashReporter)
        } catch {
            fatalError("Failed to bootstrap AppContainer: \(error)")
        }
    }

    private static var crashReporterFactory: () -> CrashReporting = {
        NoOpCrashReporter()
    }

    private(set) static var shared = sharedFactory()

    let discoStore: DiscoStore
    let userDefaultsClient: UserDefaultsClient
    let fileManagerService: FileManagerService
    let networkClient: NetworkClient
    let secureClient: SecureClient
    let crashReporter: CrashReporting

    init(
        storage: Storage,
        userDefaultsClient: UserDefaultsClient = UserDefaultsClientImpl(),
        fileManagerService: FileManagerService = FileManagerServiceImpl(),
        networkClient: NetworkClient = NetworkClientImpl(),
        secureClient: SecureClient? = nil,
        crashReporter: CrashReporting = NoOpCrashReporter()
    ) throws {
        let discoStore = try Self.makeDiscoStore(for: storage)
        let secureClient = secureClient ?? SecureClientImpl(
            server: SpotifyReferencesConstants.secureStorageServer
        )

        self.discoStore = discoStore
        self.userDefaultsClient = userDefaultsClient
        self.fileManagerService = fileManagerService
        self.networkClient = networkClient
        self.secureClient = secureClient
        self.crashReporter = crashReporter
    }

    static func configureCrashReporterFactory(_ factory: @escaping () -> CrashReporting) {
        crashReporterFactory = factory
    }

    static func setShared(_ container: AppContainer) {
        shared = container
    }

    static func resetShared() {
        shared = sharedFactory()
    }
}

private extension AppContainer {
    static func makeDiscoStore(for storage: Storage) throws -> DiscoStore {
        switch storage {
            case .persistent:
                return try CoreDataDiscoStore()
            case .inMemory(let database):
                return InMemoryDiscoStore(database: database)
            }
    }
}
