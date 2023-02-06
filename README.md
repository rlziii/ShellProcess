# ShellProcess

A lightweight wrapper around Foundation's `Process`.

## Install

Add the following dependency as a package in your `Package.swift` file or Xcode project:

```
git@github.com:rlziii/ShellProcess.git
```

## Usage

The library is made of of three simple parts:

* `Action`: An action to be fed into a `ShellProcess` to run a command. The command and arguments are part of this struct.
* `Result`: The result of running a `ShellProcess` command that represents the standard output and standard error `String`s, if any exists.
* `ShellProcess`: A struct that wraps a single `Process` to be executed. After being initialized, use the `run(_:withDirectoryURL:)` or `run(withInput:)` methods to execute the command.

### `Action`

`Action`s can be created by either making new extensions and providing an executable path (to a Unix command) along with optional arguments or by using the convenience `raw(_:)` `Action` that accepts a `String` to be used as a raw Shell script.
For example, this is an example (provided in the project) to wrap the `who` command:

```swift
public static func who(currentTerminalOnly: Bool) -> ShellProcess.Action {
  .init(executablePath: "/usr/bin/who", arguments: currentTerminalOnly ? ["-m"] : [])
}
```

And can be used like so:

```swift
ShellAction(.who(currentTerminalOnly: true)).run()
```

If a command doesn't need to accept arguments then it can be written as a static property instead of a static method:

```swift
public static let whoAmI = ShellProcess.Action(executablePath: "/usr/bin/who", arguments: ["-m"])
```

And used as such:

```swift
ShellAction(.whoAmI).run()
```

Alternatively, this could have been written using `raw`:

```swift
ShellAction(.raw("who -m")).run()
```

When using `raw(_:)`, you craft commands as though you are typing in a Terminal window.

### `Result`

The `Result` type (not to be confused with Swift's built-in `Result`) is a simple wrapper struct around two `Optional` `String`s: `standardOutput` and `standardError`.
After a `ShellAction` has finished executing (via `run(...)`), a `Result` is returned with these values potentially available, representing the stream of text that was written to the Shell's standard output and error pipes.
These return values are marked as `@discardableResult` so they can be conveniently ignored if they are not needed.

### `ShellProcess`

A `ShellProcess` is initialized with an `Action` and optionally a `directoryURL` (i.e. the directory from which to execute within).
There are two `run(...)` methods:

```swift
public func run(withInput input: String) -> Result
```

```swift
public func run(withInput input: Data? = nil) -> Result
```

The former is just a convenience method for the latter when a `String` is the desired input (which is true for most cases).
There are also `async` versions of both methods.

If the result of one `ShellProcess` is required for a subsequent command, they can be chained together in a simple way (especially using Swift's `async`/`await`).
For example:

```swift
func someFunction() async {
  let result1 = await ShellProcess(.someAction1).run()
  let result2 = await ShellProcess(.someAction2(with: result1.standardOutput)).run()
  let result3 = await ShellProcess(.someAction3(with: result2.standardOutput)).run()
  print(result3.standardOutput)
}
```