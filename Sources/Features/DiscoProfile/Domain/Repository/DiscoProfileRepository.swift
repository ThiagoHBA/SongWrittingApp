import Foundation

protocol DiscoProfileRepository:
    GetDiscoProfileUseCase,
    AddDiscoNewReferenceUseCase,
    AddNewSectionToDiscoUseCase,
    AddNewRecordToSessionUseCase,
    UpdateDiscoNameUseCase,
    DeleteDiscoUseCase,
    DeleteSectionUseCase,
    DeleteRecordUseCase {}
