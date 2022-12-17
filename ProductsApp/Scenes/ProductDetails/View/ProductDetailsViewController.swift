//
//  ProductDetailsViewController.swift
//  ProductsApp
//
//  Created by Hussein Anwar on 17/12/2022.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    //MARK: - Properties
    private var viewModel: ProductDetailsViewModelProtocol
    
    //MARK: - Init
    init(viewModel:ProductDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Methods
    func setupUI(){
        productPrice.text = "\(viewModel.model.price) $"
        productDescription.text = viewModel.model.description
        imageHeight.constant = CGFloat(viewModel.model.imageHeight)
        setProductImage()
    }
    
    fileprivate func setProductImage() {
        let url = URL(string:viewModel.model.image)
        if let data = try? Data(contentsOf: url!)
        {
            let image: UIImage = UIImage(data: data) ?? UIImage()
            productImage.image = image
        }
    }
    
    //MARK: - Actions
    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
