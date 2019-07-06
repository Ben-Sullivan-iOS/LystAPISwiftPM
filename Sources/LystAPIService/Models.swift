//
//  File.swift
//  
//
//  Created by Ben Sullivan on 03/07/2019.
//

import Foundation

public struct FilterNetworkResult: Codable {
  public let productCategories: [ProductCategory]
  
  enum CodingKeys: String, CodingKey {
    case productCategories = "filters"
  }
}

public struct ProductResult: Codable {
  public let products: [ProductNetworkModel]
}

public struct ProductNetworkModel: Codable {
  public let price: String
  public let title: String
  public let image: String
}

public struct ProductCategory: Codable {
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
