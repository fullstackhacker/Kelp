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
    var loadingMoreData = false
    
    @IBOutlet weak var businessTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.delegate = self
        searchBar.placeholder = "Find Restaurants"
        navigationItem.titleView = searchBar
        
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
        filtersViewController.currentDistance = self.filterState["distance"] as? Int ?? 3
        filtersViewController.currentSortSelectionIndex = self.filterState["sort"] as? Int ?? 0
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
    
    func reloadSearch() {
        // get search term
        let searchTerm = self.filterState["term"] as? String ?? ""
        
        // get categories
        let filterCategories = self.filterState["categories"] as? [String:Bool] ?? [String:Bool]()
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
        let dealsOnly = self.filterState["deal"] as? Bool ?? false
        
        // get distance
        let distance = self.filterState["distance"] as? Int ?? 3
        
        // get offset
        let offset  = self.filterState["offset"] as? Int ?? nil
        
        // get sorts
        let yelpSortModes = [YelpSortMode.bestMatched,
                             YelpSortMode.distance,
                             YelpSortMode.highestRated]
        let sort = yelpSortModes[self.filterState["sort"] as? Int ?? 0]
        
        Business.searchWithTerm(term: searchTerm, sort: sort, categories: categories, deals: dealsOnly, distance: distance, offset: offset) { (businesses, error) in
            if offset != nil {
                self.businesses = self.businesses + businesses!
            }
            else {
                self.businesses = businesses ?? [Business]()
            }
            self.loadingMoreData = false
            self.businessTableView.reloadData()
        }
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
        self.reloadSearch()
    }
}

extension BusinessesViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        searchBar.enablesReturnKeyAutomatically = false
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.filterState["term"] = searchBar.text as AnyObject
        self.reloadSearch()
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.showsCancelButton = false
    }
}

extension BusinessesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !self.loadingMoreData {
            let reloadThreshold = self.businessTableView.contentSize.height / 2
            
            if scrollView.contentOffset.y > reloadThreshold && scrollView.isDragging {
                self.loadingMoreData = true
                self.filterState["offset"] = self.businesses.count as AnyObject
                self.reloadSearch()
            }
            
        }
    }
}
