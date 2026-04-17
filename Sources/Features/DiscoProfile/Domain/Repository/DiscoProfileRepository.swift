import Foundation

protocol DiscoProfileRepository:
    GetDiscoProfileUseCase,
    AddDiscoNewReferenceUseCase,
    AddNewSectionToDiscoUseCase,
    AddNewRecordToSessionUseCase {}
