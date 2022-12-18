//
//  DBHelper.swift
//  ProductsApp
//
//  Created by Hussein Anwar on 18/12/2022.
//

import UIKit
import CoreData

class CachingManager{
    
    //MARK: - Properties
    private var productItems: [NSManagedObject] = []
    static let shared = CachingManager()
    
    //MARK: - Init
    private init (){}

    //MARK: - Core Data Metods
    func saveToCoreData(item: Product) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ProductEntity", in: managedContext)!
        let productItem = NSManagedObject(entity: entity, insertInto: managedContext)
        productItem.setValue(item.description, forKey: "productDescription")
        productItem.setValue(item.imageHeight, forKey: "imageHeight")
        productItem.setValue(item.image, forKey: "productImage")
        productItem.setValue(item.price, forKey: "productPrice")
        do {
            try managedContext.save()
            self.productItems.append(productItem)
            print("SAVE SUCCESS")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchItems() -> [Product]{
        var cachedList : [Product] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "ProductEntity")
        do {
            let fetchedResult = try managedContext.fetch(fetchRequest)
            for item in fetchedResult {
                let productDescription = item.value(forKey: "productDescription")! as! String
                let productPrice = item.value(forKey: "productPrice")! as! Int
                let productImage = item.value(forKey: "productImage")! as! String
                let imageHeight = item.value(forKey: "imageHeight")! as! Int
                let obj = Product.init(description: productDescription, price: productPrice, image: productImage, imageHeight: imageHeight)
                cachedList.append(obj)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return cachedList
    }
    
    func deleteCachedData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductEntity")
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let fetchedResult = try managedContext.fetch(fetchRequest)
            for managedObject in fetchedResult
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            print("DELETE SUCCESS")
        } catch let error as NSError {
            print("Detele all data in ProductEntity error : \(error) \(error.userInfo)")
        }
    }

}
