//
//  ShowViewController.swift
//  lab-test2
//
//  Created by Macbook on 5/25/21.
//

import UIKit
import CoreData

class ShowViewController: UIViewController {
    // create the context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var products: [ProductModel]?
    var managedContext: NSManagedObjectContext!
    var selectedProduct: ProductModel?
    
    weak var delegate: ProductListTVC?
    
    @IBOutlet weak var idt: UITextField!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var descp: UITextField!
    
    @IBOutlet weak var provid: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if(selectedProduct != nil){
        //Set Selected Product Data in textFields
        idt.text =  String (selectedProduct!.id)
        name.text = selectedProduct?.name
        price.text = String(selectedProduct!.price)
        descp.text = selectedProduct?.desc
        provid.text =  selectedProduct!.provider
        
        selectedProduct=nil
        }

        // Do any additional setup after loading the view.
    }
    
    
    func loadCoreData() {

        //let request: NSFetchRequest<ProductModel> = ProductModel.fetchRequest()
        
        do {
            products = try context.fetch(ProductModel.fetchRequest())
            DispatchQueue.main.async {
                self.delegate?.tableView.reloadData()
            }
            
            
        }
        catch {
            print("Error loading folders \(error.localizedDescription)")
        }
       
    }

    
    @IBAction func cancel(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func update(_ sender: Any) {
        
        let updatedId = Int16(idt.text!)!
        let updatedName = name.text
        let updatedPrice = Int16(price.text!)!
        let updatedDesp = descp.text
        let updatedProvid = provid.text
        
        selectedProduct?.id = updatedId
        selectedProduct?.name = updatedName
        selectedProduct?.price = updatedPrice
        selectedProduct?.desc = updatedDesp
        selectedProduct?.provider = updatedProvid
        
     
        
        print("done")
        
        products = []
        let newNote = ProductModel(context: context)
        newNote.name = updatedName
        do {
            try context.save()
        } catch {
            print("Error saving the product \(error.localizedDescription)")
        }
        
        //loadCoreData()
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
