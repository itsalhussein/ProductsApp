//
//  String+Ex.swift
//  ProductsApp
//
//  Created by Hussein Anwar on 18/12/2022.
//

import UIKit

extension String {
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data(base64Encoded: imageBase64String)
        let image = UIImage(data: imageData!)
        return image!
    }
}
