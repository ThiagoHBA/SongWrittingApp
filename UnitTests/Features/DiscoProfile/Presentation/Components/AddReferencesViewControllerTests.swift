import UIKit
import XCTest
@testable import Main

@MainActor
final class AddReferencesViewControllerTests: XCTestCase {
    func test_updateReferenceItems_renders_rows() throws {
        let sut = makeSUT()
        let references = [makeReference(name: "A"), makeReference(name: "B")]

        sut.updateReferenceItems(.init(references: references, hasMore: false))

        XCTAssertEqual(try numberOfRows(in: sut), 2)
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

        let tableView = try tableView(in: sut)
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

        let tableView = try tableView(in: sut)
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

        let searchBar = try XCTUnwrap(sut.view.profileFindSubview(ofType: UISearchBar.self))

        sut.searchBar(searchBar, textDidChange: "")

        XCTAssertEqual(try numberOfRows(in: sut), 0)
        XCTAssertEqual(clearSearchCalls, 1)
    }
}

private extension AddReferencesViewControllerTests {
    func makeSUT() -> AddReferencesViewController {
        let sut = AddReferencesViewController()
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

    func tableView(in sut: AddReferencesViewController) throws -> UITableView {
        try XCTUnwrap(sut.view.profileFindSubview(ofType: UITableView.self))
    }

    func searchBar(in sut: AddReferencesViewController) throws -> UISearchBar {
        try XCTUnwrap(sut.view.profileFindSubview(ofType: UISearchBar.self))
    }

    func numberOfRows(in sut: AddReferencesViewController) throws -> Int {
        let tableView = try tableView(in: sut)
        tableView.layoutIfNeeded()
        return tableView.numberOfRows(inSection: 0)
    }
}

private extension UIView {
    func profileFindSubview<T: UIView>(ofType type: T.Type) -> T? {
        if let typedView = self as? T {
            return typedView
        }

        for subview in subviews {
            if let typedView = subview.profileFindSubview(ofType: type) {
                return typedView
            }
        }

        return nil
    }
}
