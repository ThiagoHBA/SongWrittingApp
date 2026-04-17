import Foundation

struct SectionViewEntity: Equatable {
    let identifer: String
    var records: [RecordViewEntity]

    init(identifer: String, records: [RecordViewEntity]) {
        self.identifer = identifer
        self.records = records
    }

    init(from domain: Section) {
        self.identifer = domain.identifer
        self.records = domain.records.map(RecordViewEntity.init(from:))
    }

    func mapToDomain() -> Section {
        Section(
            identifer: identifer,
            records: records.map { $0.toDomain() }
        )
    }
}
