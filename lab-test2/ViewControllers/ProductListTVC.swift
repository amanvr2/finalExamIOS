//
//  ProductListTVC.swift
//  lab-test2
//
//  Created by Macbook on 5/23/21.
//

import UIKit
import CoreData

class ProductListTVC: UITableViewController {
    
   
    var pro = [ProductModel]()
    var prov = [Providers]()
    
    var deletingMovingOption: Bool = false
   
    @IBOutlet var table: UITableView!
    
    // create the context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // define a search controller
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

       showSearchBar()
      
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pro.count 
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let product = pro[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "showList",for: indexPath)
        

        cell.textLabel?.text = product.name!  + " - " + product.desc!
        cell.detailTextLabel?.text = "\(product.price) - \(product.id)"
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .darkGray
        cell.selectedBackgroundView = backgroundView
        

        return cell
    }
    

  //   Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNote(pr: pro[indexPath.row])
            saveNotes()
            
            pro.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
           
        } else if editingStyle == .insert {
            
        }
    }
    
    
    @IBAction func showProviders(_ sender: UIButton) {
        
        print((sender as AnyObject).titleLabel?.text)
        
        if (sender.titleLabel?.text == "Show Products"){
            loadCoreData(type: ProductModel())
            
            sender.setTitle("Show Providers", for: .normal)
        }else if (sender.titleLabel?.text == "Show Providers"){
            loadCoreData(type: Providers())
            sender.setTitle("View Products", for: .normal)
           
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /// delete notes from context
    /// - Parameter note: note defined in Core Data
    func deleteNote(pr: ProductModel) {
        context.delete(pr)
    }
    
    func saveNotes() {
        do {
            try context.save()
        } catch {
            print("Error saving the notes \(error.localizedDescription)")
        }
    }
    
    func loadCoreData(type: NSManagedObject) {
        
        pro.removeAll()
        
        if(type is ProductModel){

        let request: NSFetchRequest<ProductModel> = ProductModel.fetchRequest()
        
        do {
            pro = try context.fetch(request)
            
            
        }
        catch {
            print("Error loading products \(error.localizedDescription)")
        }
            
        }
        
        else if(type is Providers){
            
            let request: NSFetchRequest<Providers> = Providers.fetchRequest()
            
            do {
                prov = try context.fetch(request)
                
                
            }
            catch {
                print("Error loading providers \(error.localizedDescription)")
            }
            
        }
        
        tableView.reloadData()
        
       
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
      
        return deletingMovingOption ? false : true
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        let destination = segue.destination as! ShowViewController
        destination.delegate = self
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            if (pro[indexPath.row] is ProductModel){
                
                destination.selectedProduct =  pro[indexPath.row] as? ProductModel
            }
        }
        
    }
    
    

    
    //MARK: - Show Search Bar to serach products from listing
    func showSearchBar() {
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Product"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.searchTextField.textColor = .black
        //table.tableHeaderView = searchController.searchBar
    }
    
    /// Load Products from Core Data based on serach
    /// - Parameter predicate: parameter comming from search bar - by default is nil
    func loadSearchedProducts(predicate: NSPredicate? = nil) {
        let request: NSFetchRequest<ProductModel> = ProductModel.fetchRequest()
        
        request.predicate=predicate
        
        do {
            pro = try context.fetch(request)
        } catch {
            print("Error loading products \(error.localizedDescription)")
        }
        
        tableView.reloadData()
    }
    
    

    @IBAction func editBtn(_ sender: Any) {
        
        deletingMovingOption = !deletingMovingOption
    
        
        tableView.setEditing(deletingMovingOption, animated: true)
    }
    

}

//MARK: - search bar delegate methods
extension ProductListTVC: UISearchBarDelegate {


    /// search button on keypad functionality
    /// - Parameter searchBar: search bar is passed to this function
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // add predicate
        let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        loadSearchedProducts(predicate: predicate)
    }


    /// when the text in text bar is changed
    /// - Parameters:
    ///   - searchBar: search bar is passed to this function
    ///   - searchText: the text that is written in the search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadSearchedProducts()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}



