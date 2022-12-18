//
//  ProductCell.swift
//  ProductsApp
//
//  Created by Hussein Anwar on 17/12/2022.
//

import UIKit

class ProductCell: UICollectionViewCell {
    //MARK: - Outlets
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var cellView: UIStackView!
    
    //MARK: - Properties
    static var identifier: String {
        return String.init(describing: self)
    }
    
    static var nib: UINib {
        return UINib.init(nibName: String.init(describing: self), bundle: nil)
    }
    
    //MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - Methods
    func configureCell(model: Product){
        productPrice.text = "\(model.price) $"
        productDescription.text = model.description
        let imageStr = model.image
        productImage.image = imageStr.convertBase64StringToImage(imageBase64String: imageStr)
    }

}
