
import Clibgit2
import Tagged

public struct Note: Identifiable {
    public typealias ID = Tagged<Note, Reference.ID>
    public let id: ID
    public let objectID: Object.ID
}

extension Note {

    init(_ note: GitPointer) throws {
        guard note.check(git_reference_is_note) else { throw GitKitError.incorrectType(expected: "note") }
        id = try ID(reference: note)
        objectID = try Object.ID(reference: note)
    }
}

// MARK: - CustomDebugStringConvertible

extension Note: CustomDebugStringConvertible {
    public var debugDescription: String {
        "Note(id: \(id), objectID: \(objectID.debugDescription))"
    }
}
