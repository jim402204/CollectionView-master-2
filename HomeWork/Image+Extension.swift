//
//  Image+Extension.swift
//  HomeWork
//
//  Created by Jim on 2020/2/18.
//  Copyright © 2020 Jim. All rights reserved.
//
import UIKit

extension UIImageView{
    
//    static var currentTask = [Int : URLSessionDataTask]()
    
    static var mapping = [Int : UIImage]()
    
    func showImage(index: Int, url: URL) {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: url) { (data, response , error) in
            
            if let error = error {
                return print("Down fail:  \(error)")
            }
            
            guard let data = data else{ return assertionFailure("data is nil") }
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                self.image = image
                
            }
            
//            print("index: \(index)")
//            guard index >= 0 else { return }
//            print("index222: \(index)")
            
            DispatchQueue.main.async {
//                self.image = image
                UIImageView.mapping[index] = image
            }
            
        }
        
        task.resume()
    }
    
}
