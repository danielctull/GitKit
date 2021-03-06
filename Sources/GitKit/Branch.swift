
import Clibgit2
import Tagged

public struct Branch: Identifiable {
    let branch: GitPointer
    public typealias ID = Tagged<Branch, Reference.ID>
    public let id: ID
    public let target: Object.ID
    public let name: String
}

extension Branch {

    init(_ branch: GitPointer) throws {
        guard branch.check(git_reference_is_branch) else { throw GitKitError.incorrectType(expected: "branch") }
        self.branch = branch
        id = try ID(reference: branch)
        name = try Unwrap(String(validatingUTF8: branch.get(git_branch_name)))
        target = try Object.ID(reference: branch)
    }
}

// MARK: - CustomDebugStringConvertible

extension Branch: CustomDebugStringConvertible {
    public var debugDescription: String {
        "Branch(name: \(name), id: \(id), target: \(target.debugDescription))"
    }
}
