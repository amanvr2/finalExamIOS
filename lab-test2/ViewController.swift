//
//  ViewController.swift
//  lab-test2
//
//  Created by Macbook on 5/23/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    // 1 - creating an instance of AppDelage
    /// appDelegaet instance
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // 2 - create the context
    var managedContext: NSManagedObjectContext!
    
    @IBOutlet weak var idTxt: UITextField!
    
    @IBOutlet weak var nameTxt: UITextField!
    
    @IBOutlet weak var priceTxt: UITextField!
    @IBOutlet weak var descTxt: UITextField!
    @IBOutlet weak var providerTxt: UITextField!
    
    @IBOutlet weak var firstProd: UILabel!
    //    var product:[ProductModel]?
    
    var pro: [Product]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedContext = appDelegate.persistentContainer.viewContext

    NotificationCenter.default.addObserver(self, selector: #selector(saveCoreData), name: UIApplication.willResignActiveNotification, object: nil)

    

    loadCoreData()
    firstProduct()

}
    
    
    @IBAction func save(_ sender: Any) {
        
        
        let id = Int(idTxt.text ?? "0") ?? 0
        let name = nameTxt.text ?? ""
        let price = Int(priceTxt.text ?? "0") ?? 0
        let desc = descTxt.text ?? ""
        let provid = providerTxt.text ?? ""

        let data = Product(id: id, name: name, price: price, description: desc, provider: provid)

        pro?.append(data)
        clearfields()
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let prodListTableVC = segue.destination as? ProductListTVC {
            prodListTableVC.pro = self.pro
        }
    }
//
//        //MARK: - CoreData functions
//
        func loadCoreData() {

//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//            let managedContext = appDelegate.persistentContainer.viewContext

            pro = [Product]()

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductModel")

            do {
                
                let results = try managedContext.fetch(fetchRequest)
                if results is [NSManagedObject] {
                    for result in (results as! [NSManagedObject]) {
                        let id = result.value(forKey: "id") as! Int
                        let name = result.value(forKey: "name") as! String
                        let price = result.value(forKey: "price") as! Int
                        let description = result.value(forKey: "desc") as! String
                        let provider = result.value(forKey: "provider") as! String

                        pro?.append(Product(id: id, name: name, price: price, description: description, provider: provider))
                    }
                }

            } catch {
                print(error)
            }
        }

        @objc func saveCoreData() {
            clearCoreData()
//
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//
//            let managedContext = appDelegate.persistentContainer.viewContext

            for book in pro! {
                let bookEntity = NSEntityDescription.insertNewObject(forEntityName: "ProductModel", into: managedContext)

                bookEntity.setValue(book.id, forKey: "id")
                bookEntity.setValue(book.name, forKey: "name")
                bookEntity.setValue(book.price, forKey: "price")
                bookEntity.setValue(book.description, forKey: "desc")
                bookEntity.setValue(book.provider, forKey: "provider")
            }

            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        }


    
    
    func clearCoreData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductModel")
//        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for result in results {
                if let managedObject = result as? NSManagedObject {
                    managedContext.delete(managedObject)
                }
            }
        } catch {
            print("Error deleting records \(error)")
        }

    }
    
    func clearfields(){
        
        idTxt.text = ""
        nameTxt.text = ""
        priceTxt.text = ""
        descTxt.text = ""
        providerTxt.text = ""
    }
    
    func firstProduct(){
        
        
        pro = [Product]()

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductModel")

        do {
            
            let results = try managedContext.fetch(fetchRequest)
            
            if results is [NSManagedObject] {
                for result in (results as! [NSManagedObject]) {
                    let id = result.value(forKey: "id") as! Int
                    let name = result.value(forKey: "name") as! String
                    let price = result.value(forKey: "price") as! Int
                    let description = result.value(forKey: "desc") as! String
                    let provider = result.value(forKey: "provider") as! String

                    pro?.append(Product(id: id, name: name, price: price, description: description, provider: provider))
                    
                    firstProd.text = name
                }
            }

        } catch {
            print(error)
        }
    }


}
