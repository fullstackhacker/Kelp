//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController {
    
    var businesses: [Business]! = []
    var filterState: [String:AnyObject]! = [String:AnyObject]()
    
    @IBOutlet weak var businessTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        businessTableView.delegate = self
        businessTableView.dataSource = self
        businessTableView.rowHeight = UITableViewAutomaticDimension
        businessTableView.estimatedRowHeight = 120
        
        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            self.businessTableView.reloadData()
            }
        )
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let filtersNavigationController = segue.destination as! UINavigationController
        let filtersViewController = filtersNavigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
        filtersViewController.categoryStates = self.filterState["categories"] as? [String:Bool] ?? [String:Bool]()
        filtersViewController.deal = self.filterState["deal"] as? Bool ?? false
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
    
    
}

extension BusinessesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = businessTableView.dequeueReusableCell(withIdentifier: "BusinessCell") as! BusinessTableViewCell
        cell.business = self.businesses[indexPath.row]
        return cell
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.businesses != nil) {
            return self.businesses.count
        }
        return 0
    }
}

extension BusinessesViewController: FiltersViewControllerDelegate {
    func filtersViewController(filterViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        self.filterState = filters
        
        // get categories
        let filterCategories = self.filterState["categories"] as! [String:Bool]
        let categories = filterCategories.reduce([], { (filterCategories: [String], categoryState) -> [String] in
            let (key, value) = categoryState
            if (value) {
                var newFilterCategories = [String]()
                newFilterCategories.append(contentsOf: filterCategories)
                newFilterCategories.append(key)
                return newFilterCategories
            }
            
            return filterCategories
        })
        
        // get deal only
        let dealsOnly = self.filterState["deal"] as! Bool
        
        Business.searchWithTerm(term: "Restaurants", sort: nil, categories: categories, deals: dealsOnly) { (businesses, error) in
            self.businesses = businesses ?? [Business]()
            self.businessTableView.reloadData()
        }
    }
}
