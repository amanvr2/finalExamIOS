//
//  ProductListTVC.swift
//  lab-test2
//
//  Created by Macbook on 5/23/21.
//

import UIKit
import CoreData

class ProductListTVC: UITableViewController {
    
   // var pro: [Product]?
    var pro = [ProductModel]()
   
    @IBOutlet var table: UITableView!
    
    // create the context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // define a search controller
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

       showSearchBar()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "showList")
        cell?.textLabel?.text = product.name! + " - " + product.desc!
        cell?.detailTextLabel?.text = "\(product.price) - \(product.id)"
        

        return cell!
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

    
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



