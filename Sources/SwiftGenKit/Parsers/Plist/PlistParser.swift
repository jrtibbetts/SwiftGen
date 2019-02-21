//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

public enum Plist {
  public enum ParserError: Error, CustomStringConvertible {
    case invalidFile(path: Path, reason: String)

    public var description: String {
      switch self {
      case .invalidFile(let path, let reason):
        return "Unable to parse file at \(path). \(reason)"
      }
    }
  }

  // MARK: Plist File Parser

  public final class Parser: DefaultParser, SwiftGenKit.Parser {
    var files: [File] = []

    public static let defaultFilter = "[^/]\\.(?i:plist)$"

    public func parse(path: Path, relativeTo parent: Path) throws {
      files.append(try File(path: path, relativeTo: parent))
    }
  }
}
