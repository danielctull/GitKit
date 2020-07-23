
import Foundation
import GitKit
import XCTest

final class ReflogTests: XCTestCase {

    func testRepositoryReflog() throws {
        let remote = try Bundle.module.url(forRepository: "Test.git")
        try FileManager.default.withTemporaryDirectory { local in
            let cloneDate = Date()
            let repo = try Repository(local: local, remote: remote)
            let reflog = try repo.reflog()
            XCTAssertEqual(reflog.items.count, 1)
            let item = try XCTUnwrap(reflog.items.last)
            XCTAssertEqual(item.message, "checkout: moving from master to main")
            XCTAssertEqual(item.old.description, "0000000000000000000000000000000000000000")
            XCTAssertEqual(item.new.description, "17e26bc76cff375603e7173dac31e5183350e559")
            XCTAssertEqual(item.committer.name, "Daniel Tull")
            XCTAssertEqual(item.committer.email, "dt@danieltull.co.uk")
            // The date for a reflog item is when it occurred, in this case when
            // the repo was cloned at the start of this test.
            XCTAssertEqual(item.committer.date.timeIntervalSince1970, cloneDate.timeIntervalSince1970, accuracy: 1)
            XCTAssertEqual(item.committer.timeZone, TimeZone(secondsFromGMT: TimeZone.current.secondsFromGMT()))
        }
    }
}