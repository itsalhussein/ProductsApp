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
    private let transition = Animator()
    private var selectedIndexPathItem : IndexPath?
    
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
        setupCollectionView()
        configureBinding()
        viewModel.getData()
    }
    
    //MARK: - Methods
    private func setupCollectionView() {
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        productsCollectionView.prefetchDataSource = self
        productsCollectionView.register(ProductCell.nib, forCellWithReuseIdentifier: ProductCell.identifier)
    }
    private func configureBinding(){
        viewModel.reloadCollectionViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.productsCollectionView.reloadData()
            }
        }
        
        viewModel.convertImageURLtoBase64String = { data in
            let imageUrlString = data
            let imageUrl = URL(string: imageUrlString)!
            let imageData = try! Data(contentsOf: imageUrl)
            let image = UIImage(data: imageData)
            let strBase64 = image?.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
            return strBase64
        }
        
        transition.dismissCompletion = { [weak self] in
            guard let selectedIndexPathCell = self?.selectedIndexPathItem,
            let selectedCell = self?.productsCollectionView.cellForItem(at: selectedIndexPathCell) as? ProductCell
            else { return }
            selectedCell.cellView.isHidden = false
        }
        
    }
}

//MARK: - CollectionView delegate methods
extension ProductsViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productsCollectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
        cell.configureCell(model: viewModel.products[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPathItem = indexPath
        let vm = ProductDetailsViewModel(model: viewModel.products[indexPath.row])
        let vc = ProductDetailsViewController(viewModel: vm)
        vc.transitioningDelegate = self
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .currentContext
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK: - CollectionView FlowLayout delegate methods
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

//MARK: - Prefetching items delegate method
extension ProductsViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for index in indexPaths {
            if (index.row >= viewModel.products.count - 4) && !(viewModel.isGettingData) {
                viewModel.getData()
                break
            }
        }
    }
}

//MARK: - Transition Delegate Methods

extension ProductsViewController : UIViewControllerTransitioningDelegate {
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController, source: UIViewController)
    -> UIViewControllerAnimatedTransitioning? {
        
        guard let selectedIndexPathCell = self.selectedIndexPathItem,
        let selectedCell = self.productsCollectionView.cellForItem(at: selectedIndexPathCell) as? ProductCell,
        let selectedCellSuperview = selectedCell.superview
        else {
            return nil
        }
        
        transition.originFrame = selectedCellSuperview.convert(selectedCell.frame, to: nil)
        transition.originFrame = CGRect(
            x: transition.originFrame.origin.x,
            y: transition.originFrame.origin.y,
            width: transition.originFrame.size.width,
            height: transition.originFrame.size.height
        )
        
        transition.presenting = true
        selectedCell.cellView.isHidden = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController)
    -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
