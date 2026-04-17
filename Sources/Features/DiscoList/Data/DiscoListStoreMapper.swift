import Foundation

enum DiscoListStoreMapper {
    static func discoSummary(from storeRecord: DiscoStoreRecord) -> DiscoSummary {
        DiscoSummary(
            id: storeRecord.id,
            name: storeRecord.name,
            coverImage: storeRecord.coverImage
        )
    }

    static func storeRecord(from disco: DiscoSummary) -> DiscoStoreRecord {
        DiscoStoreRecord(
            id: disco.id,
            name: disco.name,
            coverImage: disco.coverImage
        )
    }
}
