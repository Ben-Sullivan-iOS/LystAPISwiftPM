//
//  APIParameter.swift
//  LystTestProject
//
//  Created by Ben Sullivan on 03/07/2019.
//  Copyright © 2019 Ben Sullivan. All rights reserved.
//

import Foundation

public struct APIParameter {
  let type: QueryType
  let values: [String]
  
  enum QueryType {
    case fields(String)
    case filterType
    case include
    case limit
    case query
    case precategory
    case pregender
    case preproducttype
    case custom(String)
    
    var name: String {
      switch self {
      case .fields(let string):
        return "fields[\(string)]"
      case .filterType:
        return "filter_type"
      case .precategory:
        return "pre_category"
      case .pregender:
        return "pre_gender"
      case .preproducttype:
        return "pre_product_type"
      case .limit:
        return "limit"
      case .query:
        return "query"
      case .custom(let customKey):
        return customKey
      case .include:
        return "include"
      }
    }
  }
  
  var queryItem: URLQueryItem {
    return URLQueryItem(name: self.type.name, value: values.joined(separator: ","))
  }
}
