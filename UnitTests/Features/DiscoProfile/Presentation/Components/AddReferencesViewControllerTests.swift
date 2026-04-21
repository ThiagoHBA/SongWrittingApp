import UIKit
import XCTest
@testable import Main

@MainActor
final class AddReferencesViewControllerTests: XCTestCase {
    func test_updateReferenceItems_renders_rows() throws {
        let sut = makeSUT()
        let references = [makeReference(name: "A"), makeReference(name: "B")]

        sut.updateReferenceItems(.init(references: references, hasMore: false))

        XCTAssertEqual(try sut.numberOfRows(), 2)
    }

    func test_willDisplay_requests_next_page_once_when_near_bottom() throws {
        let sut = makeSUT()
        var loadMoreRequests = 0
        sut.loadMoreReferences = { loadMoreRequests += 1 }
        sut.updateReferenceItems(
            .init(
                references: [
                    makeReference(name: "A"),
                    makeReference(name: "B"),
                    makeReference(name: "C")
                ],
                hasMore: true
            )
        )

        let tableView = try sut.tableView()
        let searchBar = try searchBar(in: sut)
        searchBar.text = "album"

        sut.tableView(tableView, willDisplay: UITableViewCell(), forRowAt: IndexPath(row: 2, section: 0))
        sut.tableView(tableView, willDisplay: UITableViewCell(), forRowAt: IndexPath(row: 2, section: 0))

        XCTAssertEqual(loadMoreRequests, 1)
    }

    func test_updateReferenceItems_afterLoadingMore_allows_next_page_request_again() throws {
        let sut = makeSUT()
        var loadMoreRequests = 0
        sut.loadMoreReferences = { loadMoreRequests += 1 }
        sut.updateReferenceItems(
            .init(references: [makeReference(name: "A"), makeReference(name: "B")], hasMore: true)
        )

        let tableView = try sut.tableView()
        let searchBar = try searchBar(in: sut)
        searchBar.text = "album"

        sut.tableView(tableView, willDisplay: UITableViewCell(), forRowAt: IndexPath(row: 1, section: 0))
        sut.updateReferenceItems(
            .init(
                references: [
                    makeReference(name: "A"),
                    makeReference(name: "B"),
                    makeReference(name: "C")
                ],
                hasMore: true
            )
        )
        sut.tableView(tableView, willDisplay: UITableViewCell(), forRowAt: IndexPath(row: 2, section: 0))

        XCTAssertEqual(loadMoreRequests, 2)
    }

    func test_searchBarCleared_resets_results_and_notifies_clearSearch() throws {
        let sut = makeSUT()
        var clearSearchCalls = 0
        sut.clearSearch = { clearSearchCalls += 1 }
        sut.updateReferenceItems(.init(references: [makeReference()], hasMore: true))

        let searchBar = try XCTUnwrap(sut.view.findSubview(ofType: UISearchBar.self))

        sut.searchBar(searchBar, textDidChange: "")

        XCTAssertEqual(try sut.numberOfRows(), 0)
        XCTAssertEqual(clearSearchCalls, 1)
    }

    func test_providerSelection_clears_results_and_notifies_selected_provider() throws {
        let sut = makeSUT()
        var selectedProvider: SearchReferenceViewEntity?
        sut.selectReferenceProvider = { selectedProvider = $0 }
        sut.updateReferenceItems(.init(references: [makeReference()], hasMore: true))

        sut.selectProvider(.init(from: .lastFM))

        XCTAssertEqual(try sut.numberOfRows(), 0)
        XCTAssertEqual(selectedProvider, SearchReferenceViewEntity(from: .lastFM))
        XCTAssertEqual(sut.selectedProvider, SearchReferenceViewEntity(from: .lastFM))
    }

    func test_viewDidLoad_renders_provider_menu_from_view_entities() throws {
        let sut = makeSUT()
        let navBar = try XCTUnwrap(sut.view.findSubview(ofType: UINavigationBar.self))
        let saveItem = try XCTUnwrap(navBar.items?.first?.rightBarButtonItem)
        let searchBar = try searchBar(in: sut)
        let providerButton = try XCTUnwrap(sut.view.findSubview(ofType: SWIconButton.self))
        let actions = try XCTUnwrap(providerButton.menu?.children as? [UIAction])

        sut.view.layoutIfNeeded()

        XCTAssertNotNil(saveItem)
        XCTAssertEqual(actions.count, 2)
        XCTAssertEqual(actions[0].title, "Spotify")
        XCTAssertEqual(actions[1].title, "Last.fm")
        XCTAssertEqual(actions[0].state, .on)
        XCTAssertEqual(actions[1].state, .off)
        XCTAssertEqual(providerButton.accessibilityLabel, "Provedor de busca: Spotify")
    }
}

private extension AddReferencesViewControllerTests {
    func makeSUT() -> AddReferencesViewController {
        let sut = AddReferencesViewController()
        sut.searchProviders = ReferenceProvider.allCases.map(SearchReferenceViewEntity.init(from:))
        sut.selectedProvider = SearchReferenceViewEntity(from: .spotify)
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = sut
        window.makeKeyAndVisible()
        sut.loadViewIfNeeded()
        return sut
    }

    func makeReference(
        name: String = "Album",
        artist: String = "Artist",
        releaseDate: String = "2024-01-01",
        coverImage: URL? = URL(string: "https://example.com/image")
    ) -> AlbumReferenceViewEntity {
        AlbumReferenceViewEntity(
            name: name,
            artist: artist,
            releaseDate: releaseDate,
            coverImage: coverImage
        )
    }

    func searchBar(in sut: AddReferencesViewController) throws -> UISearchBar {
        try XCTUnwrap(sut.view.findSubview(ofType: UISearchBar.self))
    }

}
