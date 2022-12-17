//
//  ProductDetailsViewModel.swift
//  ProductsApp
//
//  Created by Hussein Anwar on 17/12/2022.
//

import Foundation

protocol ProductDetailsViewModelProtocol {
    var imageHeight : Int { get set }
    var model : Product { get set }
}

class ProductDetailsViewModel : ProductDetailsViewModelProtocol {
    //MARK: - Properties
    var model: Product
    var imageHeight = 0
    
    //MARK: - Init
    init(model: Product) {
        self.model = model
    }   
}
