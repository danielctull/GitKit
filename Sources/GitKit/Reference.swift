
import Clibgit2
import Tagged

public enum Reference {
    case branch(Branch)
    case note(Note)
    case remoteBranch(RemoteBranch)
    case tag(Tag)
}

extension Reference {

    init(_ reference: GitPointer) throws {

        switch reference {

        case let reference where reference.check(git_reference_is_branch):
            self = try .branch(Branch(reference))

        case let reference where reference.check(git_reference_is_note):
            self = try .note(Note(reference))

        case let reference where reference.check(git_reference_is_remote):
            self = try .remoteBranch(RemoteBranch(reference))

        case let reference where reference.check(git_reference_is_tag):
            self = try .tag(Tag(reference))

        default:
            struct UnknownReferenceType: Error {}
            throw UnknownReferenceType()
        }
    }
}

// Reference.ID

extension Reference: Identifiable {

    public typealias ID = Tagged<Reference, String>

    public var id: ID {
        switch self {
        case let .branch(branch): return ID(rawValue: branch.id.rawValue)
        case let .note(note): return ID(rawValue: note.id.rawValue)
        case let .remoteBranch(remoteBranch): return ID(rawValue: remoteBranch.id.rawValue)
        case let .tag(tag): return ID(rawValue: tag.id.rawValue)
        }
    }
}

// Getters

extension Reference {

    var tag: Tag? {
        guard case .tag(let tag) = self else { return nil }
        return tag
    }
}
