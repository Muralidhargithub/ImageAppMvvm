//
//  SubscriberPro.swift
//  ImageAppMvvm
//
//  Created by Muralidhar reddy Kakanuru on 12/9/24.
//


//
//  Networkmanager.swift
//  SubscriberApp
//
//  Created by Muralidhar reddy Kakanuru on 12/9/24.
//

import Foundation
import UIKit

protocol ImageDef {
    func getData<T:Codable>(url:String, completion: @escaping @Sendable (T) -> ())
    func getImage(url: String, completion: @escaping (UIImage?) -> ())
}

class ImageNetwork: ImageDef{
    // MARK: Properties
    
    static let sharedInstance = ImageNetwork()
    let urlSession: URLSession
    var imageCache = NSCache<NSString, UIImage>()
    
    //MARK: INitialization
    private init() {
        let config = URLSessionConfiguration.default
        self.urlSession = URLSession(configuration: config)
    }
    
    //MARK: Function to fetch data
    func getData<T:Codable>(url:String, completion: @escaping @Sendable (T) -> ()) {
        guard let serverURL = URL(string: url) else {
            print("invalid url")
            return
        }
        urlSession.dataTask(with: serverURL) { data, _, error in
            if let error = error {
                print("error occured \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print(" data did not parsed")
                return
            }
            do{
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(decoded)
            }
            catch{
                print("the data unable to decode into Json format")
            }
        }.resume()
    }
    
    //MARK: Function to fetchImages
    func getImage(url: String, completion: @escaping (UIImage?) -> ()) {
        if let cachedImage = imageCache.object(forKey: url as NSString){
            completion(cachedImage)
        }
        
        guard let serverURL = URL(string: url) else {
            print("invalid url")
            return
        }
        
        urlSession.dataTask(with: serverURL) { data, _, error in
            if let error = error {
                print("error occured \(error.localizedDescription)")
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                print(" data did not parsed")
                return
            }
            self.imageCache.setObject(image, forKey: serverURL.absoluteString as NSString)
            completion(image)
        }.resume()
    }
}

