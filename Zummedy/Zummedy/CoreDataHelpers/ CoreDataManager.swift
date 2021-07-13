//
//   CoreDataManager.swift
//  DynamicPopup
//
//  Created by Hitesh on 12/07/21.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    static let sharedManager = CoreDataManager()
    var manageContext: NSManagedObjectContext?
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ProductModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func addData(productData:ProductData) {
        manageContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        guard let manageContext = self.manageContext else {
            return
        }
        guard let entity = NSEntityDescription.entity(forEntityName: "ProductModel",in: manageContext) else {
            return
        }
        let product = NSManagedObject(entity: entity,
                                      insertInto: manageContext)
        product.setValue(productData.id, forKey: "id")
        product.setValue(productData.price, forKey: "price")
        product.setValue(productData.category?.rawValue, forKey: "category")
        product.setValue(productData.title, forKey: "title")
        product.setValue(productData.alarmDataClassDescription, forKey: "productDescription")
        product.setValue(0, forKey: "itemsCount")
        product.setValue(false, forKey: "isBookmark")
        do {
            try manageContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveImageData(data:Data,id:Int){
        
        manageContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        guard let manageContext = self.manageContext else {
            return
        }
        let productModel = self.fetchAllProducts()
        _ = productModel?.map({ model -> ProductModel in
            if model.id == id{
                model.img = data
            }
            return model
        })
        do {
            try manageContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    func fetchAllProducts() -> [ProductModel]?{
        manageContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        guard let manageContext = self.manageContext else {
            return nil
        }
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProductModel")
        do {
            let products = try manageContext.fetch(fetchRequest)
            return products as? [ProductModel]
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func updateItemsCount(id:Int,count:Int16) -> Int {
        manageContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        guard let manageContext = self.manageContext else {
            return 0
        }
        let products = self.fetchAllProducts()
        var items = 0
        _ = products?.map({ model -> ProductModel in
            if model.id == id{
                model.itemsCount += count
                items = Int(model.itemsCount)
            }
            return model
        })
        do {
            try manageContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return items
    }
    
}
