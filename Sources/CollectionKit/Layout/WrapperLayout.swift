//
//  WrapperLayout.swift
//  CollectionKit
//
//  Created by Luke Zhao on 2017-09-11.
//  Copyright © 2017 lkzhao. All rights reserved.
//

import UIKit

public protocol WrapperLayout: Layout {
  var rootLayout: Layout { get }
}
extension WrapperLayout {
  public var contentSize: CGSize { rootLayout.contentSize }
  public func layout(context: LayoutContext) {
    rootLayout.layout(context: context)
  }
  public func visibleIndexes(visibleFrame: CGRect) -> [Int] {
    rootLayout.visibleIndexes(visibleFrame: visibleFrame)
  }
  public func frame(at: Int) -> CGRect {
    rootLayout.frame(at: at)
  }
}
