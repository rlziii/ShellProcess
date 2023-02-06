import Foundation

public extension ShellProcess {
    /// Run the process with a `String` as input, asynchronously awaiting the `Result`.
    /// - Parameter input: The input to the `ShellProcess`.
    /// - Returns: An asynchronous `Result` which contains the standard output and error from running the process.
    @discardableResult
    func run(withInput input: String) async -> Result {
        await withCheckedContinuation { continuation in
            Task {
                let result = run(withInput: input)
                continuation.resume(returning: result)
            }
        }
    }

    /// Run the process, optionally with `Data` as input, asynchronously awaiting the `Result`.
    /// - Parameter input: The optional input to the `ShellProcess`.
    /// - Returns: An asynchronous `Result` which contains the standard output and error from running the process.
    @discardableResult
    func run(withInput input: Data? = nil) async -> Result {
        await withCheckedContinuation { continuation in
            Task {
                let result = run(withInput: input)
                continuation.resume(returning: result)
            }
        }
    }
}
