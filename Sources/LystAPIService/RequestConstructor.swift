//
//  APIConstructor.swift
//  LystTestProject
//
//  Created by Ben Sullivan on 03/07/2019.
//  Copyright © 2019 Ben Sullivan. All rights reserved.
//

import UIKit

public class APIRequestConstructor {
  
  private static var baseURL: String {
    //  Computed property as generally used to switch between dev and prod environments
    return "mobileapi.lystit.com"
  }
  
  enum HTTPMethod: String {
    case post = "POST"
    case put = "PUT"
    case get = "GET"
    case delete = "DELETE"
    case patch = "PATCH"
  }
  
  struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
      self.key = key
      self.mimeType = "image/jpg"
      self.filename = "image"
      guard let data = image.jpegData(compressionQuality: 0.5) else { return nil }
      self.data = data
    }
  }
  
  static func request(for endpoint: Endpoint, method: HTTPMethod, excludeCache: Bool = false, ids: [Int]? = nil, parameters: [APIParameter]? = nil, body: [String: Any]? = nil, pathSuffix: String? = nil) -> URLRequest? {
    guard let url = url(for: endpoint, excludeCache: excludeCache, ids: ids, parameters: parameters, pathSuffix: pathSuffix) else { return nil }
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    
    if let body = body, let data = try? JSONSerialization.data(withJSONObject: body) {
      request.httpBody = data
    }
    
    return request
  }
  
  static func multiPartRequest(for endpoint: Endpoint, method: HTTPMethod, media: [Media]?, parameters: [String: String]?) -> URLRequest? {
    guard let url = url(for: endpoint) else { return nil }
    let boundary = "Boundary-\(UUID().uuidString)"
    
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.httpBody = createMultiPartBody(withParameters: parameters, media: media, boundary: boundary)
    return request
  }
  
  static func downloadRequest(for url: String) -> URLRequest? {
    guard let url = URL(string: url) else { return nil }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    return request
  }
  
  private static func url(for endpoint: Endpoint, excludeCache: Bool = false, ids: [Int]? = nil, parameters: [APIParameter]? = nil, pathSuffix: String? = nil) -> URL? {
    var components = URLComponents()
    components.scheme = "https"
    components.percentEncodedHost = baseURL
    components.queryItems = parameters?.compactMap({ $0.queryItem })
    
    if excludeCache {
      let random = Int.random(in: 0...999999999)
      if components.queryItems == nil {
        components.queryItems = [URLQueryItem(name: "cache", value: String(random))]
      } else {
        components.queryItems?.append(URLQueryItem(name: "cache", value: String(random)))
      }
    }
    
    let idString = ids?.compactMap({ String($0) }).joined(separator: ",")
    components.path = "/" + [endpoint.string, idString, pathSuffix].compactMap({ $0 }).joined(separator: "/")
    components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
    
    return components.url
  }
  
  
  // MARK: Multi Part request helper methods
  private static func createMultiPartBody(withParameters params: [String: String]?, media: [Media]?, boundary: String) -> Data {
    let lineBreak = "\r\n"
    var body = Data()
    
    if let parameters = params {
      for (key, value) in parameters {
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
        body.append("\(value + lineBreak)")
      }
    }
    
    if let media = media {
      for photo in media {
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
        body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
        body.append(photo.data)
        body.append(lineBreak)
      }
    }
    
    body.append("--\(boundary)--\(lineBreak)")
    
    return body
  }
  
  private static func generateBoundary() -> String {
    return "Boundary-\(UUID().uuidString)"
  }
}

// MARK: Helper for Data
private extension Data {
  mutating func append(_ string: String) {
    if let data = string.data(using: .utf8) {
      append(data)
    }
  }
}
