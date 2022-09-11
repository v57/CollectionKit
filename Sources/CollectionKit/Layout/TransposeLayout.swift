//
//  TransposeLayout.swift
//  CollectionKit
//
//  Created by Luke Zhao on 2017-09-08.
//  Copyright © 2017 lkzhao. All rights reserved.
//

import UIKit

open class TransposeLayout: WrapperLayout {
  public var rootLayout: Layout
  public init(_ rootLayout: Layout) {
    self.rootLayout = rootLayout
  }
  open var contentSize: CGSize {
    rootLayout.contentSize.transposed
  }

  open func layout(context: LayoutContext) {
    rootLayout.layout(context: Context(context: context))
  }

  open func visibleIndexes(visibleFrame: CGRect) -> [Int] {
    rootLayout.visibleIndexes(visibleFrame: visibleFrame.transposed)
  }

  open func frame(at: Int) -> CGRect {
    rootLayout.frame(at: at).transposed
  }
  private struct Context: ProxyLayoutContext {
    var context: LayoutContext
    var collectionSize: CGSize {
      context.collectionSize.transposed
    }
    func size(at: Int, collectionSize: CGSize) -> CGSize {
      context.size(at: at, collectionSize: collectionSize.transposed).transposed
    }
  }
}
