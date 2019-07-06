//
//  APIService.swift
//  LystTestProject
//
//  Created by Ben Sullivan on 03/07/2019.
//  Copyright © 2019 Ben Sullivan. All rights reserved.
//

import Foundation

public protocol APIServiceType {
  func getShoeCategories(forGender gender: Gender, completion: @escaping (Result<FilterNetworkResult, Error>) -> ())
  func getProducts(forProductTypes productTypes: [ProductCategory], completion: @escaping (Result<(allCategories: [String], productResult: ProductResult), Error>) -> ())
}

public struct APIService: APIServiceType {
  
  public init() { }
  public func getShoeCategories(forGender gender: Gender, completion: @escaping (Result<FilterNetworkResult, Error>) -> ()) {
    guard let request = APIRequestConstructor.request(
      for: .filter,
      method: .get,
      excludeCache: false,
      ids: [],
      parameters: [
        APIParameter(type: .pregender, values: [gender.rawValue]),
        APIParameter(type: .preproducttype, values: ["Shoes"]),
        APIParameter(type: .filterType, values: ["category"]),
      ],
      body: nil,
      pathSuffix: nil)
      else {
        //handle error
        return
    }
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
      
      do {
        let categories = try JSONDecoder().decode(FilterNetworkResult.self, from: data!)
        completion(Result.success(categories))
      } catch {
        print(error)
      }
    })
    
    task.resume()
  }
  
  public func getProducts(forProductTypes productTypes: [ProductCategory], completion: @escaping (Result<(allCategories: [String], productResult: ProductResult), Error>) -> ()) {
    
    var params = [APIParameter]()
    
    var allCategories = [String]()
    
    productTypes.forEach { product in
      params.append(APIParameter(type: .precategory, values: [product.value]))
      allCategories.append(product.value)
    }
    
    guard let request = APIRequestConstructor.request(
      for: .feeds,
      method: .get,
      excludeCache: false,
      ids: [],
      parameters: params,
      body: nil,
      pathSuffix: nil)
      else {
        //Handle error
        return
    }
    
    let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
      
      do {
        let products = try JSONDecoder().decode(ProductResult.self, from: data!)
        
        print(products)
        completion(Result.success((allCategories: allCategories, productResult: products)))
        
      } catch {
        print(error)
      }
      
    })
    
    task.resume()
  }
  
  public func downloadImageData(withURL url: URL, completion: @escaping (Result<Data, Error>) -> ()) {
    
    let request = URLRequest(url: url)
    let session = URLSession.shared
    
    let task = session.dataTask(with: request) { imageData, URLResponse, error in
      
      guard let imageData = imageData else {
        //handle error
        return
      }
      
      DispatchQueue.main.async {
        completion(.success(imageData))
      }
    }
    task.resume()
  }
  
}
