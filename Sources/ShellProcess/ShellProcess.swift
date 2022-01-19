import Foundation

/// A wrapper around `Process` to run an `Action` to represent a shell command.
public struct ShellProcess {
    private let process: Process
    private let standardOutputPipe: Pipe
    private let standardErrorPipe: Pipe

    /// Create a new `ShellProcess` with an `Action`.
    /// - Parameters:
    ///   - action: The `Action` from which to configure the `ShellProcess`.
    ///   - directoryURL: The directory to act as the `Process`'s current working directory; if `nil` then the script's
    ///                   current working directory is used instead.
    public init(_ action: Action, withDirectoryURL directoryURL: URL? = nil) {
        self.process = Process()
        self.standardOutputPipe = Pipe()
        self.standardErrorPipe = Pipe()

        process.executableURL = action.executableURL
        process.arguments = action.arguments
        process.standardOutput = standardOutputPipe
        process.standardError = standardErrorPipe

        if let directoryURL = directoryURL {
            process.currentDirectoryURL = directoryURL
        }
    }

    /// Run the process with a `String` as input.
    /// - Parameter input: The input to the `ShellProcess`.
    /// - Returns: A `Result` which contains the standard output and error from running the process.
    @discardableResult
    public func run(withInput input: String) -> Result {
        run(withInput: Data(input.utf8))
    }

    /// Run the process, optionally with `Data` as input.
    /// - Parameter input: The optional input to the `ShellProcess`.
    /// - Returns: A `Result` which contains the standard output and error from running the process.
    @discardableResult
    public func run(withInput input: Data? = nil) -> Result {
        do {
            if let input = input {
                let standardInputPipe = Pipe()
                process.standardInput = standardInputPipe
                try standardInputPipe.fileHandleForWriting.write(contentsOf: input)
            }

            try process.run()
            process.waitUntilExit()

            return Result(
                standardOutput: try readPipe(standardOutputPipe),
                standardError: try readPipe(standardErrorPipe)
            )
        } catch {
            print("Could not execute process. Error: \(error.localizedDescription)")
            return .empty
        }
    }

    private func readPipe(_ pipe: Pipe) throws -> String? {
        guard let data = try pipe.fileHandleForReading.readToEnd() else {
            return nil
        }

        return String(decoding: data, as: UTF8.self).trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
