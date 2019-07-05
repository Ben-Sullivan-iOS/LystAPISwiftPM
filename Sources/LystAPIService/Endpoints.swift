//
//  Endpoints.swift
//  LystTestProject
//
//  Created by Ben Sullivan on 03/07/2019.
//  Copyright © 2019 Ben Sullivan. All rights reserved.
//

import Foundation

public enum Endpoint {
  case feeds
  case filter
  case players
  case homefeed
  
  var string: String {
    switch self {
    case .feeds:
      return "rest_api/components/feeds"
    case .filter:
      return "rest_api/components/filter_options"
    case .players:
      return "players"
    case .homefeed:
      return "home-feed-items"
    }
  }
  
}
