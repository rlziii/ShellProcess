import Foundation

extension ShellProcess {
    /// The standard output and error, if any, received from running a `ShellProcess` action.
    public struct Result {
        public let standardOutput: String?
        public let standardError: String?

        /// Print both the `standardOutput` and `standardError` if not `nil`.
        public func print() {
            if let standardOutput = standardOutput {
                Swift.print(standardOutput)
            }

            if let standardError = standardError {
                Swift.print(standardError)
            }
        }
    }
}

extension ShellProcess.Result {
    /// A convenience to create a `ShellProcess.Result` with `nil` output and error.
    public static let empty = ShellProcess.Result(standardOutput: nil, standardError: nil)
}
