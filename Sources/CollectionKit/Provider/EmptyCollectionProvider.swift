//
//  BaseCollectionProvider.swift
//  CollectionKit
//
//  Created by Luke Zhao on 2017-08-15.
//  Copyright © 2017 lkzhao. All rights reserved.
//

import UIKit

open class EmptyCollectionProvider: ItemProvider, CollectionReloadable {
  open var identifier: String?

  public init(identifier: String? = nil) {
    self.identifier = identifier
  }

  open var numberOfItems: Int {
    0
  }
  open func view(at: Int) -> UIView {
    UIView()
  }
  open func update(view: UIView, at: Int) {}
  open func identifier(at: Int) -> String {
    "\(at)"
  }

  open var contentSize: CGSize {
    .zero
  }
  open func layout(collectionSize: CGSize) {}
  open func frame(at: Int) -> CGRect {
    .zero
  }
  open func visibleIndexes(visibleFrame: CGRect) -> [Int] {
    [Int]()
  }

  open func animator(at: Int) -> Animator? {
    nil
  }

  open func willReload() {}
  open func didReload() {}
  open func didTap(view: UIView, at: Int) {}

  open func hasReloadable(_ reloadable: CollectionReloadable) -> Bool {
    reloadable === self
  }
}
