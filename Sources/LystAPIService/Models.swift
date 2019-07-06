//
//  File.swift
//  
//
//  Created by Ben Sullivan on 03/07/2019.
//

import Foundation

public struct FilterNetworkModel: Codable {
  public let productCategories: [ProductCategoryNetworkModel]
  
  enum CodingKeys: String, CodingKey {
    case productCategories = "filters"
  }
}

public struct ProductContainerNetworkModel: Codable {
  public let products: [ProductNetworkModel]
}

public struct ProductNetworkModel: Codable {
  public let price: String
  public let title: String
  public let image: String
}

public struct ProductCategoryNetworkModel: Codable {
  public init(value: String) {
    self.value = value
  }
  public let value: String
}

public enum ProductType: String {
  case shoes = "Shoes"
}

public enum Gender: String {
  case male = "M"
  case female = "F"
}
