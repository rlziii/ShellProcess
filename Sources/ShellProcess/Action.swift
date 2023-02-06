import Foundation

extension ShellProcess {
    /// A pairing of a shell command and its arguments.
    /// - Note: Implement `Action`s with conditional arguments as `static` functions.
    public struct Action {
        let executableURL: URL
        let arguments: [String]
    }
}

extension ShellProcess.Action {
    /// A convenience initializer to use a static path to describe the executable.
    /// - Parameters:
    ///   - executablePath: The executable path for the `Action` to be passed to the `Process`.
    ///   - arguments: The arguments for the `Action` to be passed to the `Process`.
    public init(executablePath: StaticString, arguments: [String]) {
        self.executableURL = URL(fileURLWithPath: executablePath.string())
        self.arguments = arguments
    }
}

extension ShellProcess.Action {
    /// An `Action` to invokes the "who" command to display who is logged in.
    ///
    /// This is just an example `Action`.
    ///
    /// - Parameter currentTerminalOnly: When `true`, only returns information about the current terminal (i.e. "whoami").
    /// - Returns: An `Action` to be used by a `ShellProcess`.
    public static func who(currentTerminalOnly: Bool) -> ShellProcess.Action {
        .init(executablePath: "/usr/bin/who", arguments: currentTerminalOnly ? ["-m"] : [])
    }

    /// An `Action` to invokes the "whoami" command to display who is logged in for the current terminal.
    ///
    /// This is just an example `Action`.
    ///
    /// - Returns: An `Action` to be used by a `ShellProcess`.
    public static let whoAmI = ShellProcess.Action(executablePath: "/usr/bin/whoami", arguments: [""])

    /// An `Action` that allows for processing raw shell commands.
    /// - Parameter rawString: A raw command to be passed into a shell, e.g. "who -m".
    /// - Returns: An `Action` to be used by a `ShellProcess`.
    public static func raw(_ rawString: String) -> ShellProcess.Action {
        .init(executablePath: "/bin/sh", arguments: ["-c", rawString])
    }
}

private extension StaticString {
    /// Constructs the UTF8 `String` representation of the `StaticString`.
    /// - Returns: The converted `String`.
    func string() -> String {
        withUTF8Buffer { .init(decoding: $0, as: UTF8.self) }
    }
}
