//
//  InsetLayout.swift
//  CollectionKit
//
//  Created by Luke Zhao on 2017-09-08.
//  Copyright © 2017 lkzhao. All rights reserved.
//

import UIKit

open class InsetLayout: WrapperLayout {
  public var rootLayout: Layout
  public var insets: UIEdgeInsets
  public var insetProvider: ((CGSize) -> UIEdgeInsets)?
  public init(_ rootLayout: Layout, insets: UIEdgeInsets = .zero) {
    self.insets = insets
    self.rootLayout = rootLayout
  }

  public init(_ rootLayout: Layout, insetProvider: @escaping ((CGSize) -> UIEdgeInsets)) {
    self.insets = .zero
    self.insetProvider = insetProvider
    self.rootLayout = rootLayout
  }

  open var contentSize: CGSize {
    rootLayout.contentSize.insets(by: -insets)
  }

  open func layout(context: LayoutContext) {
    if let insetProvider = insetProvider {
      insets = insetProvider(context.collectionSize)
    }
    rootLayout.layout(context: Context(context: context, insets: insets))
  }

  open func visibleIndexes(visibleFrame: CGRect) -> [Int] {
    rootLayout.visibleIndexes(visibleFrame: visibleFrame.inset(by: -insets))
  }
  open func frame(at: Int) -> CGRect {
    rootLayout.frame(at: at) + CGPoint(x: insets.left, y: insets.top)
  }
  
  private struct Context: ProxyLayoutContext {
    var context: LayoutContext
    var insets: UIEdgeInsets
    var collectionSize: CGSize {
      context.collectionSize.insets(by: insets)
    }
  }
}
