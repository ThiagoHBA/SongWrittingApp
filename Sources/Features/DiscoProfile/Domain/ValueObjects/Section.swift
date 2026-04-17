import Foundation

struct Section: Equatable {
    let identifer: String
    var records: [Record]
    
    init(identifer: String, records: [Record]) throws {
        if identifer.isEmpty {
            throw DiscoProfileError.CreateSectionError.emptyName
        }
        
        self.identifer = identifer
        self.records = records
    }
}
