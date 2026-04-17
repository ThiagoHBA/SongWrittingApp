import Foundation

enum DiscoProfileStoreMapper {
    static func profile(from storeRecord: DiscoProfileStoreRecord) -> DiscoProfile {
        DiscoProfile(
            disco: DiscoSummary(
                id: storeRecord.disco.id,
                name: storeRecord.disco.name,
                coverImage: storeRecord.disco.coverImage
            ),
            references: storeRecord.references.map(albumReference(from:)),
            section: storeRecord.section.compactMap(section(from:))
        )
    }

    static func storeProfile(from profile: DiscoProfile) -> DiscoProfileStoreRecord {
        DiscoProfileStoreRecord(
            disco: storeDisco(from: profile.disco),
            references: profile.references.map(storeReference(from:)),
            section: profile.section.map(storeSection(from:))
        )
    }

    static func storeDisco(from disco: DiscoSummary) -> DiscoStoreRecord {
        DiscoStoreRecord(id: disco.id, name: disco.name, coverImage: disco.coverImage)
    }

    static func storeReference(from reference: AlbumReference) -> AlbumReferenceStoreRecord {
        AlbumReferenceStoreRecord(
            name: reference.name,
            artist: reference.artist,
            releaseDate: reference.releaseDate,
            coverImage: reference.coverImage
        )
    }

    static func storeSection(from section: Section) -> SectionStoreRecord {
        SectionStoreRecord(
            identifer: section.identifer,
            records: section.records.map(storeRecord(from:))
        )
    }

    static func storeRecord(from record: Record) -> RecordStoreRecord {
        RecordStoreRecord(
            tag: storeTag(from: record.tag),
            audio: record.audio
        )
    }

    private static func albumReference(from storeRecord: AlbumReferenceStoreRecord) -> AlbumReference {
        AlbumReference(
            name: storeRecord.name,
            artist: storeRecord.artist,
            releaseDate: storeRecord.releaseDate,
            coverImage: storeRecord.coverImage
        )
    }

    private static func section(from storeRecord: SectionStoreRecord) -> Section? {
        try? Section(
            identifer: storeRecord.identifer,
            records: storeRecord.records.map(record(from:))
        )
    }

    private static func record(from storeRecord: RecordStoreRecord) -> Record {
        Record(tag: domainTag(from: storeRecord.tag), audio: storeRecord.audio)
    }

    private static func storeTag(from tag: InstrumentTag) -> InstrumentTagStoreRecord {
        switch tag {
        case .guitar:
            return .guitar
        case .vocal:
            return .vocal
        case .drums:
            return .drums
        case .bass:
            return .bass
        case .custom(let value):
            return .custom(value)
        }
    }

    private static func domainTag(from tag: InstrumentTagStoreRecord) -> InstrumentTag {
        switch tag {
        case .guitar:
            return .guitar
        case .vocal:
            return .vocal
        case .drums:
            return .drums
        case .bass:
            return .bass
        case .custom(let value):
            return .custom(value)
        }
    }
}
