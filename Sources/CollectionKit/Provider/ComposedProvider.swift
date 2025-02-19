//
//  ComposedProvider.swift
//  CollectionKit
//
//  Created by Luke Zhao on 2017-07-20.
//  Copyright © 2017 lkzhao. All rights reserved.
//

import UIKit

open class ComposedProvider: SectionProvider, LayoutableProvider, CollectionReloadable {

  open var identifier: String?
  open var sections: [Provider] { didSet { setNeedsReload() } }
  open var animator: Animator? { didSet { setNeedsReload() } }
  open var layout: Layout { didSet { setNeedsInvalidateLayout() } }

  public init(identifier: String? = nil,
              layout: Layout = FlowLayout(),
              animator: Animator? = nil,
              sections: [Provider] = []) {
    self.animator = animator
    self.layout = layout
    self.sections = sections
    self.identifier = identifier
  }

  open var numberOfItems: Int {
    sections.count
  }

  open func section(at: Int) -> Provider? {
    sections[at]
  }

  open func identifier(at: Int) -> String {
    sections[at].identifier ?? "\(at)"
  }

  open func layoutContext(collectionSize: CGSize) -> LayoutContext {
    Context(
      collectionSize: collectionSize,
      sections: sections
    )
  }

  open func animator(at: Int) -> Animator? {
    animator
  }

  open func willReload() {
    for section in sections {
      section.willReload()
    }
  }

  open func didReload() {
    for section in sections {
      section.didReload()
    }
  }

  open func hasReloadable(_ reloadable: CollectionReloadable) -> Bool {
    reloadable === self || sections.contains(where: { $0.hasReloadable(reloadable) })
  }
  
  private struct Context: LayoutContext {
    var collectionSize: CGSize
    var sections: [Provider]
    var numberOfItems: Int { sections.count }
    func data(at: Int) -> Any { sections[at] }
    func identifier(at: Int) -> String { sections[at].identifier ?? "\(at)" }
    func size(at: Int, collectionSize: CGSize) -> CGSize {
      sections[at].layout(collectionSize: collectionSize)
      return sections[at].contentSize
    }
  }
}
