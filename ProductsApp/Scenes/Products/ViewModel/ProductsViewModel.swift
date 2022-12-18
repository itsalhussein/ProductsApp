//
//  ProductsViewModel.swift
//  ProductsApp
//
//  Created by Hussein Anwar on 17/12/2022.
//

import Foundation

protocol ProductsViewModelProtocol{
    var isGettingData : Bool { get set }
    var products : [Product] { get }
    var reloadCollectionViewClosure: (()->())? { get set }
    var convertImageURLtoBase64String: ((_ str: String)->(String))? { get set }
    func getData()
}

class ProductsViewModel : ProductsViewModelProtocol {
    var isGettingData: Bool = false
    var reloadCollectionViewClosure: (()->())?
    var convertImageURLtoBase64String: ((_ str: String)->(String))?
    let cachingObj = CachingManager.shared
    var products : [Product] = [] {
        didSet {
            reloadCollectionViewClosure?()
        }
    }
    
    func getData() {
        self.isGettingData = true
        ProductsService.getData { result in
            switch result {
            case .success(let data):
                DispatchQueue.global(qos: .userInitiated).async {
                    data.forEach { obj in
                        var tempObj = Product()
                        tempObj.price = obj.price ?? 0
                        tempObj.description = obj.productDescription ?? ""
                        let imgStr = self.convertImageURLtoBase64String?(obj.image?.url ?? "")
                        tempObj.image = imgStr ?? ""
                        tempObj.imageHeight = obj.image?.height ?? 0
                        self.products.append(tempObj)
                    }
                    
                    //first API call after the connection returns, deleting all the old cached data to update it with the new ones
                    if self.products.count <= 20 {
                        DispatchQueue.main.async {
                            self.cachingObj.deleteCachedData()
                        }
                    }
            
                    self.saveProductsToCoreData()
                    DispatchQueue.main.async {
                        // Update UI
                        self.isGettingData = false
                    }
                }
            case .failure(let error):
                if error == .timeOut {
                    DispatchQueue.main.async { [weak self] in
                        let cachedData = self?.cachingObj.fetchItems()
                        self?.products = cachedData ?? []
                    }
                } else if error == .invalidURL {
                    print("invalid URL",error.localizedDescription)
                }
            }
        }
    }
    func saveProductsToCoreData(){
        DispatchQueue.main.async { [weak self] in
            self?.products.forEach { obj in
                self?.cachingObj.saveToCoreData(item: obj)
            }
        }
    }
}
