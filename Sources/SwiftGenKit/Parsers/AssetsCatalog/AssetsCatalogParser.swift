//
// SwiftGenKit
// Copyright © 2019 SwiftGen
// MIT Licence
//

import Foundation
import PathKit

public enum AssetsCatalog {
  public final class Parser: DefaultParser, SwiftGenKit.Parser {
    var catalogs = [Catalog]()

    public static let defaultFilter = "[^/]\\.xcassets$"

    public func parse(path: Path, relativeTo parent: Path) throws {
      let catalog = Catalog(path: path)
      catalogs += [catalog]
    }
  }
}
