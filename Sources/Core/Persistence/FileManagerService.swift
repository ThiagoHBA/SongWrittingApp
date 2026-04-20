import Foundation

enum FileManagerServiceError: LocalizedError, Equatable {
    case cantAccessSecurityScopedResource
    case cantResolveDocumentsDirectory
    case cantCopyFile

    var errorDescription: String? {
        switch self {
        case .cantAccessSecurityScopedResource:
            return "Não foi possível acessar o arquivo selecionado"
        case .cantResolveDocumentsDirectory:
            return "Não foi possível acessar o diretório local para salvar o arquivo"
        case .cantCopyFile:
            return "Não foi possível salvar o arquivo selecionado"
        }
    }
}

protocol FileManagerService {
    func persistFile(at sourceURL: URL) throws -> URL
}

final class FileManagerServiceImpl: FileManagerService {
    private let fileManager: FileManager

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    func persistFile(at sourceURL: URL) throws -> URL {
        let isSecurityScoped = sourceURL.startAccessingSecurityScopedResource()
        defer {
            if isSecurityScoped {
                sourceURL.stopAccessingSecurityScopedResource()
            }
        }

        guard sourceURL.isFileURL else {
            throw FileManagerServiceError.cantAccessSecurityScopedResource
        }

        guard let documentsDirectory = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            throw FileManagerServiceError.cantResolveDocumentsDirectory
        }

        let destinationURL = documentsDirectory.appendingPathComponent(sourceURL.lastPathComponent)

        if fileManager.fileExists(atPath: destinationURL.path) {
            try? fileManager.removeItem(at: destinationURL)
        }

        do {
            try fileManager.copyItem(at: sourceURL, to: destinationURL)
            return destinationURL
        } catch {
            throw FileManagerServiceError.cantCopyFile
        }
    }
}
