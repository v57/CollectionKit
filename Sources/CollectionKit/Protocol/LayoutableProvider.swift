//
//  LayoutableProvider.swift
//  CollectionKit
//
//  Created by Luke Zhao on 2018-06-13.
//  Copyright © 2018 lkzhao. All rights reserved.
//

import UIKit

public protocol LayoutableProvider {
  var layout: Layout { get }
  var internalLayout: Layout { get }
  func layoutContext(collectionSize: CGSize) -> LayoutContext
}

extension LayoutableProvider where Self: Provider {
  public var internalLayout: Layout { layout }
  public func layout(collectionSize: CGSize) {
    internalLayout.layout(context: layoutContext(collectionSize: collectionSize))
  }
  public func visibleIndexes(visibleFrame: CGRect) -> [Int] {
    internalLayout.visibleIndexes(visibleFrame: visibleFrame)
  }
  public var contentSize: CGSize { internalLayout.contentSize }
  public func frame(at: Int) -> CGRect { internalLayout.frame(at: at) }
}
