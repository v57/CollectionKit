//
//  ArrayDataSource.swift
//  CollectionKit
//
//  Created by Luke Zhao on 2017-08-15.
//  Copyright © 2017 lkzhao. All rights reserved.
//

import Foundation

public typealias IdentifierMapperFn<Data> = (Int, Data) -> String

open class ArrayDataSource<Data>: DataSource<Data> {

  open var data: [Data] {
    didSet {
      setNeedsReload()
    }
  }

  open var identifierMapper: IdentifierMapperFn<Data> {
    didSet {
      setNeedsReload()
    }
  }

  public init(data: [Data] = [], identifierMapper: @escaping IdentifierMapperFn<Data> = { index, _ in "\(index)" }) {
    self.data = data
    self.identifierMapper = identifierMapper
  }

  open override var numberOfItems: Int {
    data.count
  }

  open override func identifier(at: Int) -> String {
    identifierMapper(at, data[at])
  }

  open override func data(at: Int) -> Data {
    data[at]
  }
}
