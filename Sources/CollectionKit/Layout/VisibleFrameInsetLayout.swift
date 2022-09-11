//
//  VisibleFrameInsetLayout.swift
//  CollectionKit
//
//  Created by Luke Zhao on 2018-03-23.
//  Copyright © 2018 lkzhao. All rights reserved.
//

import UIKit

open class VisibleFrameInsetLayout: WrapperLayout {
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

  open func layout(context: LayoutContext) {
    if let insetProvider = insetProvider {
      insets = insetProvider(context.collectionSize)
    }
    rootLayout.layout(context: context)
  }

  open func visibleIndexes(visibleFrame: CGRect) -> [Int] {
    rootLayout.visibleIndexes(visibleFrame: visibleFrame.inset(by: insets))
  }
}
