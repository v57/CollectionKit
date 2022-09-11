//
//  Layout.swift
//  CollectionKit
//
//  Created by Luke Zhao on 2017-07-20.
//  Copyright © 2017 lkzhao. All rights reserved.
//

import UIKit

public protocol Layout {
  func layout(context: LayoutContext)
  var contentSize: CGSize { get }
  func frame(at: Int) -> CGRect
  func visibleIndexes(visibleFrame: CGRect) -> [Int]
}

extension Layout {
  public func transposed() -> TransposeLayout {
    TransposeLayout(self)
  }
  public func inset(by insets: UIEdgeInsets) -> InsetLayout {
    InsetLayout(self, insets: insets)
  }
  public func insetVisibleFrame(by insets: UIEdgeInsets) -> VisibleFrameInsetLayout {
    VisibleFrameInsetLayout(self, insets: insets)
  }
}
