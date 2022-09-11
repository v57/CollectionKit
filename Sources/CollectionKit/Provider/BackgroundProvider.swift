//
//  File.swift
//  
//
//  Created by Dmitry Kozlov on 14.02.2022.
//

import UIKit

open class BackgroundProvider<HeaderView: UIView>:
  SectionProvider, ItemProvider, LayoutableProvider, CollectionReloadable {

  public typealias HeaderViewSource = ViewSource<Void, HeaderView>

  open var identifier: String?

  open var sections: [Provider] {
    didSet { setNeedsReload() }
  }

  open var animator: Animator? {
    didSet { setNeedsReload() }
  }

  open var headerViewSource: HeaderViewSource {
    didSet { setNeedsReload() }
  }

  open var layout: Layout {
    get { backgroundLayout.rootLayout }
    set {
      backgroundLayout.rootLayout = newValue
      setNeedsInvalidateLayout()
    }
  }

  open var tapHandler: TapHandler?

  public typealias TapHandler = (TapContext) -> Void

  public struct TapContext {
    public let view: HeaderView
    public let index: Int
    public let section: Provider
  }

  private var backgroundLayout: BackgroundViewLayout
  public var internalLayout: Layout { backgroundLayout }

  public init(identifier: String? = nil,
              layout: Layout = FlowLayout(),
              animator: Animator? = nil,
              headerViewSource: HeaderViewSource,
              sections: [Provider] = [],
              tapHandler: TapHandler? = nil) {
    self.animator = animator
    self.backgroundLayout = BackgroundViewLayout(layout)
    self.sections = sections
    self.identifier = identifier
    self.headerViewSource = headerViewSource
    self.tapHandler = tapHandler
  }

  open var numberOfItems: Int { sections.count + 1 }
  open func section(at: Int) -> Provider? {
    at == 0 ? nil : sections[at - 1]
  }

  open func identifier(at: Int) -> String {
    at == 0 ? "background" : sections[at - 1].identifier ?? "\(at)"
  }

  open func layoutContext(collectionSize: CGSize) -> LayoutContext {
    Context(
      collectionSize: collectionSize,
      sections: sections
    )
  }

  open func animator(at: Int) -> Animator? { animator }
  open func view(at: Int) -> UIView {
    headerViewSource.view(data: (), index: 0)
  }

  open func update(view: UIView, at: Int) {
    headerViewSource.update(view: view as! HeaderView, data: (), index: 0)
  }

  open func didTap(view: UIView, at: Int) {
    if let tapHandler = tapHandler {
      let index = at - 1
      let context = TapContext(view: view as! HeaderView, index: index, section: sections[index])
      tapHandler(context)
    }
  }

  open func willReload() {
    sections.forEach { $0.willReload() }
  }

  open func didReload() {
    sections.forEach { $0.didReload() }
  }

  // MARK: private stuff
  open func hasReloadable(_ reloadable: CollectionReloadable) -> Bool {
    reloadable === self || sections.contains(where: { $0.hasReloadable(reloadable) })
  }

  open func flattenedProvider() -> ItemProvider {
    FlattenedProvider(provider: self)
  }

  private struct Context: LayoutContext {
    var collectionSize: CGSize
    var sections: [Provider]
    var numberOfItems: Int { sections.count + 1 }
    func data(at: Int) -> Any {
      at == 0 ? () : sections[at - 1]
    }
    func identifier(at: Int) -> String {
      at == 0 ? "background" : sections[at - 1].identifier ?? "\(at)"
    }
    func size(at index: Int, collectionSize: CGSize) -> CGSize {
      if index == 0 {
        return CGSize(width: collectionSize.width, height: 0)
      } else {
        sections[index - 1].layout(collectionSize: collectionSize)
        return sections[index - 1].contentSize
      }
    }
  }
}

private class BackgroundViewLayout: WrapperLayout {
  var rootLayout: Layout
  init(_ rootLayout: Layout) {
    self.rootLayout = rootLayout
  }
  func visibleIndexes(visibleFrame: CGRect) -> [Int] {
    var oldVisible = rootLayout.visibleIndexes(visibleFrame: visibleFrame)
    if let index = oldVisible.firstIndex(of: 0) {
      oldVisible.remove(at: index)
    }
    return [0] + oldVisible
  }
  func frame(at index: Int) -> CGRect {
    if index == 0 {
      return CGRect(origin: rootLayout.frame(at: index).origin, size: contentSize)
    } else {
      return rootLayout.frame(at: index)
    }
  }
}
