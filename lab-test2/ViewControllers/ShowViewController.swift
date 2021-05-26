//
//  ShowViewController.swift
//  lab-test2
//
//  Created by Macbook on 5/25/21.
//

import UIKit
import CoreData

class ShowViewController: UIViewController {
    
    var products: [ProductModel]?
    var managedContext: NSManagedObjectContext!
    var selectedProduct: ProductModel?
    
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
    
    
    @IBAction func cancel(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
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
