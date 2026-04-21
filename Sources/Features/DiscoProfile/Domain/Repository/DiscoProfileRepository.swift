import Foundation

protocol DiscoProfileRepository:
    GetDiscoProfileUseCase,
    GetDiscoReferencesUseCase,
    AddDiscoNewReferenceUseCase,
    AddNewSectionToDiscoUseCase,
    AddNewRecordToSessionUseCase,
    UpdateDiscoNameUseCase,
    DeleteDiscoUseCase,
    DeleteSectionUseCase,
    DeleteRecordUseCase {}
