//
//  ProductsViewModel.swift
//  ProductsApp
//
//  Created by Hussein Anwar on 17/12/2022.
//

import Foundation

protocol ProductsViewModelProtocol{
    func getData()
    var products : [Product] { get }
    var reloadCollectionView: (()->())? { get set }
}

class ProductsViewModel : ProductsViewModelProtocol {
    var reloadCollectionView: (()->())?
    var products : [Product] = [] {
        didSet {
            reloadCollectionView?()
        }
    }
    
    func getData() {
        ProductsService.getData { result in
            switch result {
            case .success(let data):
                data.forEach { obj in
                    var tempObj = Product()
                    tempObj.price = obj.price ?? 0
                    tempObj.description = obj.productDescription ?? ""
                    tempObj.image = obj.image?.url ?? ""
                    tempObj.imageHeight = obj.image?.height ?? 0
                    self.products.append(tempObj)
                }
                print("Products ",self.products)
            case .failure(let error):
                if error == .timeOut {
                    print("Time out",error.localizedDescription)
                } else if error == .invalidURL {
                    print("invalid URL",error.localizedDescription)
                }
            }
        }
    }
}
