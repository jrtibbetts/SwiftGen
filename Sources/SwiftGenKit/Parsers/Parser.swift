//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

public protocol Parser {
  init(options: [String: Any], warningHandler: MessageHandler?) throws

  // regex for the default filter
  static var defaultFilter: String { get }

  // Parsing and context generation
  func parse(path: Path, relativeTo parent: Path) throws
  func stencilContext() -> [String: Any]

  /// This callback will be called when a Parser wants to emit a diagnostic
  /// message. Set this on the usage-site to a closure that prints the
  /// diagnostics in any way you see fit.
  ///
  /// - parameter message: The warning message.
  /// - parameter file: The filename.
  /// - parameter line: The line number associated with the warning.
  typealias MessageHandler = (_ message: String, _ file: String, _ line: UInt) -> Void

  /// A closure that prints a warning message.
  var warningHandler: MessageHandler? { get set }
}

/// Base class for parsers. Note that it cannot implement `SwiftGenKit.Parser`
/// _itself_, because it cannot provide any meaningful default
/// `parse(path: Path, relativeTo parent: Path)` implementation. Instead, the
/// various parsers should extend the base class _and_ implement the
/// `SwiftGenKit.Parser` protocol.
public class DefaultParser: NSObject {
  /// A closure that prints a warning message.
  public var warningHandler: Parser.MessageHandler?

  public required init(options: [String: Any] = [:], warningHandler: Parser.MessageHandler? = nil) {
    self.warningHandler = warningHandler
  }
}

public extension Parser {
  func searchAndParse(paths: [Path], filter: Filter) throws {
    for path in paths {
      try searchAndParse(path: path, filter: filter)
    }
  }

  func searchAndParse(path: Path, filter: Filter) throws {
    if path.matches(filter: filter) {
      let parentDir = path.absolute().parent()
      try parse(path: path, relativeTo: parentDir)
    } else {
      let dirChildren = path.iterateChildren(options: [.skipsHiddenFiles, .skipsPackageDescendants])
      let parentDir = path.absolute()

      for path in dirChildren where path.matches(filter: filter) {
        try parse(path: path, relativeTo: parentDir)
      }
    }
  }
}
