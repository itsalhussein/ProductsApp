//
//  ProductsViewController.swift
//  ProductsApp
//
//  Created by Hussein Anwar on 17/12/2022.
//

import UIKit

class ProductsViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    //MARK: - Properties
    private var viewModel: ProductsViewModelProtocol
    
    //MARK: - Init
    init(viewModel:ProductsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getData()
        setupCollectionView()
        configureBinding()
    }
    
    //MARK: - Methods
    func setupCollectionView() {
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        productsCollectionView.register(ProductCell.nib, forCellWithReuseIdentifier: ProductCell.identifier)
    }
    func configureBinding(){
        viewModel.reloadCollectionView = { [weak self] in
            self?.productsCollectionView.reloadData()
        }
    }
}

//MARK: - Collection view methods
extension ProductsViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productsCollectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
        cell.configureCell(model: viewModel.products[indexPath.row])
        return cell
    }
}

extension ProductsViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let collectionViewWidth = collectionView.bounds.width
            let height = viewModel.products[indexPath.row].imageHeight + 80
            return CGSize(width: Int(collectionViewWidth)/2, height: height)
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
}


