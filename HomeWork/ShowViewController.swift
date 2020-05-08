//
//  ShowViewController.swift
//  HomeWork
//
//  Created by Jim on 2020/2/17.
//  Copyright © 2020 Jim. All rights reserved.
//

import UIKit

class ShowViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let collectionViewReuseID = String(describing: CollectionViewCell.self)
    var models = [Model]()
    
//    var selfIndex = []
    
    
    var mapping = [Int : UIImage]()
    var isInShow = Set<Int>()
    var showmapping = [Int : UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configtrueCollectionView()
        callAPI()
    }

}

extension ShowViewController {
    
    func configtrueCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        let nib = UINib(nibName: collectionViewReuseID, bundle: .main)
        collectionView.register(nib, forCellWithReuseIdentifier: collectionViewReuseID)
        
        //storyboard 估計值要打開 寬度約束優先權設定變低
//        codeLayout()
    }
    
    func codeLayout() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.estimatedItemSize = .zero

        let length = floor((UIScreen.main.bounds.width - 3) / 4)
        layout.itemSize = CGSize(width: length, height: length)
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
    }
    
    func callAPI() {
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let decoder = JSONDecoder()
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos/") else { return }
        
        session.dataTask(with: url) { (data, urlResponse, error) in
            
            guard error == nil else { return print("error: \(String(describing: error))") }
            guard let data = data else { return }
//            print("data: \(String.init(bytes: data, encoding: .utf8))")
            
            guard let model = try? decoder.decode([Model].self, from: data) else { return assertionFailure("decoder fail") }
//            print("model: \(model)")    //photos?albumId=1 共50子筆
            
            self.models = model
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }.resume()
        
    }
    
}


extension ShowViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewReuseID, for: indexPath) as! CollectionViewCell

        
        if let url = URL(string: models[indexPath.row].url) {
            
            let tempDirectory = FileManager.default.temporaryDirectory
            let imageFileUrl = tempDirectory.appendingPathComponent(url.lastPathComponent)
            if FileManager.default.fileExists(atPath: imageFileUrl.path) {
               let image = UIImage(contentsOfFile: imageFileUrl.path)
                item.showImageView.image = image
                
                
            }
            else
            {
                item.showImageView.image = nil
                
                item.tag = indexPath.row
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                   if let data = data, let image = UIImage(data: data) {
                      DispatchQueue.main.async {
                      if item.tag == indexPath.row{
                          item.showImageView.image = UIImage(data: data)
                      }
                    }
                   }
                }
                task.resume()
            }
            
        }
        
        
        
        return item
    }
    
    
    
    func mappingData(collectionView:UICollectionView) -> UICollectionView {
        
        
        return collectionView
    }
    
}

extension ShowViewController: UIScrollViewDelegate {
    
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        
//        if scrollView is UICollectionView {
//            print("scrollViewDidEndDecelerating")
//            
//            
//            for item in self.collectionView.visibleCells {
//
//                if let item = item as? CollectionViewCell {
//                    guard let index = collectionView.indexPath(for: item) else { continue }
//                    
//                    print("index: \(index.row)")
//                    
//                    
//                    
//                }
//            }
//            
//            
//            
//        }
//        
//    }
    
}
