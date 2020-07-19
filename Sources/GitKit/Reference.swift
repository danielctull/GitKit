
import Clibgit2

public enum Reference {
    case branch(Branch)
    case note
    case remoteBranch(RemoteBranch)
    case tag
}

extension Reference {

    init(_ reference: GitPointer) throws {

        switch reference {

        case let reference where reference.check(git_reference_is_branch):
            self = try .branch(Branch(reference))

        case let reference where reference.check(git_reference_is_note):
            self = .note

        case let reference where reference.check(git_reference_is_remote):
            self = try .remoteBranch(RemoteBranch(reference))

        case let reference where reference.check(git_reference_is_tag):
            self = .tag

        default:
            struct UnknownReferenceType: Error {}
            throw UnknownReferenceType()
        }
    }
}

extension Reference {

    var branch: Branch? {
        guard case .branch(let branch) = self else { return nil }
        return branch
    }

    var remoteBranch: RemoteBranch? {
        guard case .remoteBranch(let remoteBranch) = self else { return nil }
        return remoteBranch
    }
}
