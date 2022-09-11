//
//  LayoutContext.swift
//  CollectionKit
//
//  Created by Luke Zhao on 2018-06-07.
//  Copyright © 2018 lkzhao. All rights reserved.
//

import UIKit

public protocol LayoutContext {
  var collectionSize: CGSize { get }
  var numberOfItems: Int { get }
  func data(at: Int) -> Any
  func identifier(at: Int) -> String
  func size(at index: Int, collectionSize: CGSize) -> CGSize
}
public protocol ProxyLayoutContext: LayoutContext {
  var context: LayoutContext { get }
}
extension ProxyLayoutContext {
  public var collectionSize: CGSize { context.collectionSize }
  public var numberOfItems: Int { context.numberOfItems }
  public func data(at: Int) -> Any { context.data(at: at) }
  public func identifier(at: Int) -> String { context.identifier(at: at) }
  public func size(at index: Int, collectionSize: CGSize) -> CGSize {
    context.size(at: index, collectionSize: collectionSize)
  }
}
