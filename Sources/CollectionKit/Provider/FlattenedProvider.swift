//
//  FlattenedProvider.swift
//  CollectionKit
//
//  Created by Luke Zhao on 2018-06-08.
//  Copyright © 2018 lkzhao. All rights reserved.
//

import UIKit

public struct FlattenedProvider: ItemProvider {

  var provider: SectionProvider

  private var childSections: [(beginIndex: Int, sectionData: ItemProvider?)]

  public init(provider: SectionProvider) {
    self.provider = provider
    var childSections: [(beginIndex: Int, sectionData: ItemProvider?)] = []
    childSections.reserveCapacity(provider.numberOfItems)
    var count = 0
    for i in 0..<provider.numberOfItems {
      let sectionData: ItemProvider?
      if let section = provider.section(at: i) {
        sectionData = section.flattenedProvider()
      } else {
        sectionData = nil
      }
      childSections.append((beginIndex: count, sectionData: sectionData))
      count += sectionData?.numberOfItems ?? 1
    }
    self.childSections = childSections
  }

  func indexPath(_ index: Int) -> (Int, Int) {
    let sectionIndex = childSections.binarySearch { $0.beginIndex <= index } - 1
    return (sectionIndex, index - childSections[sectionIndex].beginIndex)
  }

  func apply<T>(_ index: Int, with: (ItemProvider, Int) -> T) -> T {
    let (sectionIndex, item) = indexPath(index)
    if let sectionData = childSections[sectionIndex].sectionData {
      return with(sectionData, item)
    } else {
      assert(provider is ItemProvider, "Provider don't support view index")
      return with(provider as! ItemProvider, sectionIndex)
    }
  }

  public var identifier: String? {
    return provider.identifier
  }

  public var numberOfItems: Int {
    return (childSections.last?.beginIndex ?? 0) + (childSections.last?.sectionData?.numberOfItems ?? 0)
  }

  public func view(at: Int) -> UIView {
    return apply(at) {
      $0.view(at: $1)
    }
  }

  public func update(view: UIView, at: Int) {
    return apply(at) {
      $0.update(view: view, at: $1)
    }
  }

  public func identifier(at: Int) -> String {
    let (sectionIndex, item) = indexPath(at)
    if let sectionData = childSections[sectionIndex].sectionData {
      return provider.identifier(at: sectionIndex) + "-" + sectionData.identifier(at: item)
    } else {
      return provider.identifier(at: sectionIndex)
    }
  }

  public func layout(collectionSize: CGSize) {
    provider.layout(collectionSize: collectionSize)
  }

  public var contentSize: CGSize {
    return provider.contentSize
  }

  public func visibleIndexes(visibleFrame: CGRect) -> [Int] {
    var visible = [Int]()
    for sectionIndex in provider.visibleIndexes(visibleFrame: visibleFrame) {
      let beginIndex = childSections[sectionIndex].beginIndex
      if let sectionData = childSections[sectionIndex].sectionData {
        let sectionFrame = provider.frame(at: sectionIndex)
        let intersectFrame = visibleFrame.intersection(sectionFrame)
        let visibleFrameForCell = CGRect(origin: intersectFrame.origin - sectionFrame.origin, size: intersectFrame.size)
        let sectionVisible = sectionData.visibleIndexes(visibleFrame: visibleFrameForCell)
        for item in sectionVisible {
          visible.append(item + beginIndex)
        }
      } else {
        visible.append(beginIndex)
      }
    }
    return visible
  }

  public func frame(at: Int) -> CGRect {
    let (sectionIndex, item) = indexPath(at)
    if let sectionData = childSections[sectionIndex].sectionData {
      var frame = sectionData.frame(at: item)
      frame.origin += provider.frame(at: sectionIndex).origin
      return frame
    } else {
      return provider.frame(at: sectionIndex)
    }
  }

  public func animator(at: Int) -> Animator? {
    return apply(at) {
      $0.animator(at: $1)
    } ?? provider.animator(at: at)
  }

  public func willReload() {
    provider.willReload()
  }

  public func didReload() {
    provider.didReload()
  }

  public func didTap(view: UIView, at: Int) {
    return apply(at) {
      $0.didTap(view: view, at: $1)
    }
  }

  public func hasReloadable(_ reloadable: CollectionReloadable) -> Bool {
    return provider.hasReloadable(reloadable)
  }
}
