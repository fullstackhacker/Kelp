//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Mushaheed Kapadia on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

enum FiltersSections : String {
    case Categories = "Categories"
    case Sort = "Sort"
    case Distance = "Distance"
    case Deals = "Deals"
}

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filterViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

class FiltersViewController: UIViewController {
  
    @IBOutlet weak var categoriesTableView: UITableView!
    
    weak var delegate: FiltersViewControllerDelegate?
    
    let sections: [FiltersSections] = [.Sort,
                                       .Distance,
                                       .Deals,
                                       .Categories]
    // deal related prefs
    var deal: Bool = false
    
    // category related prefs
    var displayedCategories: ArraySlice<Category> = []
    var showingAllCategories = false
    var categories: [Category] = []
    var categoryStates: [String: Bool] = [String: Bool]()
    
    // distance related prefs
    var distances: [Int] = [3, 5, 10, 25]
    var currentDistance: Int = 3
    var distanceDropDownOpen: Bool = false
    
    // sort related prefs
    var sorts: [String] = ["Best Match", "Distance", "Highest Rated"]
    var currentSortSelectionIndex: Int = 0
    var sortDropDownOpen: Bool = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categories = getCategories()
        self.displayedCategories = self.categories.prefix(3)
 
        self.categoriesTableView.delegate = self
        self.categoriesTableView.dataSource = self
        self.categoriesTableView.reloadData()
        
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    
    @IBAction func onSearch(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        var updatedFilters: [String: AnyObject] = [String:AnyObject]()
        
        // add category filter
        updatedFilters["categories"] = self.categoryStates as AnyObject
        
        // add deal filter
        updatedFilters["deal"] = self.deal as AnyObject
        
        // add distance filter
        updatedFilters["distance"] = self.currentDistance as AnyObject

        // add sorts filter
        updatedFilters["sort"] = self.currentSortSelectionIndex as AnyObject
        
        // reset offset
        updatedFilters["offset"] = nil

        delegate?.filtersViewController?(filterViewController: self, didUpdateFilters: updatedFilters)
    }

    func getCategories() -> [Category] {
        let categoriesDict = [["name" : "Afghan", "code": "afghani"],
                          ["name" : "African", "code": "african"],
                          ["name" : "American, New", "code": "newamerican"],
                          ["name" : "American, Traditional", "code": "tradamerican"],
                          ["name" : "Arabian", "code": "arabian"],
                          ["name" : "Argentine", "code": "argentine"],
                          ["name" : "Armenian", "code": "armenian"],
                          ["name" : "Asian Fusion", "code": "asianfusion"],
                          ["name" : "Asturian", "code": "asturian"],
                          ["name" : "Australian", "code": "australian"],
                          ["name" : "Austrian", "code": "austrian"],
                          ["name" : "Baguettes", "code": "baguettes"],
                          ["name" : "Bangladeshi", "code": "bangladeshi"],
                          ["name" : "Barbeque", "code": "bbq"],
                          ["name" : "Basque", "code": "basque"],
                          ["name" : "Bavarian", "code": "bavarian"],
                          ["name" : "Beer Garden", "code": "beergarden"],
                          ["name" : "Beer Hall", "code": "beerhall"],
                          ["name" : "Beisl", "code": "beisl"],
                          ["name" : "Belgian", "code": "belgian"],
                          ["name" : "Bistros", "code": "bistros"],
                          ["name" : "Black Sea", "code": "blacksea"],
                          ["name" : "Brasseries", "code": "brasseries"],
                          ["name" : "Brazilian", "code": "brazilian"],
                          ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
                          ["name" : "British", "code": "british"],
                          ["name" : "Buffets", "code": "buffets"],
                          ["name" : "Bulgarian", "code": "bulgarian"],
                          ["name" : "Burgers", "code": "burgers"],
                          ["name" : "Burmese", "code": "burmese"],
                          ["name" : "Cafes", "code": "cafes"],
                          ["name" : "Cafeteria", "code": "cafeteria"],
                          ["name" : "Cajun/Creole", "code": "cajun"],
                          ["name" : "Cambodian", "code": "cambodian"],
                          ["name" : "Canadian", "code": "New)"],
                          ["name" : "Canteen", "code": "canteen"],
                          ["name" : "Caribbean", "code": "caribbean"],
                          ["name" : "Catalan", "code": "catalan"],
                          ["name" : "Chech", "code": "chech"],
                          ["name" : "Cheesesteaks", "code": "cheesesteaks"],
                          ["name" : "Chicken Shop", "code": "chickenshop"],
                          ["name" : "Chicken Wings", "code": "chicken_wings"],
                          ["name" : "Chilean", "code": "chilean"],
                          ["name" : "Chinese", "code": "chinese"],
                          ["name" : "Comfort Food", "code": "comfortfood"],
                          ["name" : "Corsican", "code": "corsican"],
                          ["name" : "Creperies", "code": "creperies"],
                          ["name" : "Cuban", "code": "cuban"],
                          ["name" : "Curry Sausage", "code": "currysausage"],
                          ["name" : "Cypriot", "code": "cypriot"],
                          ["name" : "Czech", "code": "czech"],
                          ["name" : "Czech/Slovakian", "code": "czechslovakian"],
                          ["name" : "Danish", "code": "danish"],
                          ["name" : "Delis", "code": "delis"],
                          ["name" : "Diners", "code": "diners"],
                          ["name" : "Dumplings", "code": "dumplings"],
                          ["name" : "Eastern European", "code": "eastern_european"],
                          ["name" : "Ethiopian", "code": "ethiopian"],
                          ["name" : "Fast Food", "code": "hotdogs"],
                          ["name" : "Filipino", "code": "filipino"],
                          ["name" : "Fish & Chips", "code": "fishnchips"],
                          ["name" : "Fondue", "code": "fondue"],
                          ["name" : "Food Court", "code": "food_court"],
                          ["name" : "Food Stands", "code": "foodstands"],
                          ["name" : "French", "code": "french"],
                          ["name" : "French Southwest", "code": "sud_ouest"],
                          ["name" : "Galician", "code": "galician"],
                          ["name" : "Gastropubs", "code": "gastropubs"],
                          ["name" : "Georgian", "code": "georgian"],
                          ["name" : "German", "code": "german"],
                          ["name" : "Giblets", "code": "giblets"],
                          ["name" : "Gluten-Free", "code": "gluten_free"],
                          ["name" : "Greek", "code": "greek"],
                          ["name" : "Halal", "code": "halal"],
                          ["name" : "Hawaiian", "code": "hawaiian"],
                          ["name" : "Heuriger", "code": "heuriger"],
                          ["name" : "Himalayan/Nepalese", "code": "himalayan"],
                          ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
                          ["name" : "Hot Dogs", "code": "hotdog"],
                          ["name" : "Hot Pot", "code": "hotpot"],
                          ["name" : "Hungarian", "code": "hungarian"],
                          ["name" : "Iberian", "code": "iberian"],
                          ["name" : "Indian", "code": "indpak"],
                          ["name" : "Indonesian", "code": "indonesian"],
                          ["name" : "International", "code": "international"],
                          ["name" : "Irish", "code": "irish"],
                          ["name" : "Island Pub", "code": "island_pub"],
                          ["name" : "Israeli", "code": "israeli"],
                          ["name" : "Italian", "code": "italian"],
                          ["name" : "Japanese", "code": "japanese"],
                          ["name" : "Jewish", "code": "jewish"],
                          ["name" : "Kebab", "code": "kebab"],
                          ["name" : "Korean", "code": "korean"],
                          ["name" : "Kosher", "code": "kosher"],
                          ["name" : "Kurdish", "code": "kurdish"],
                          ["name" : "Laos", "code": "laos"],
                          ["name" : "Laotian", "code": "laotian"],
                          ["name" : "Latin American", "code": "latin"],
                          ["name" : "Live/Raw Food", "code": "raw_food"],
                          ["name" : "Lyonnais", "code": "lyonnais"],
                          ["name" : "Malaysian", "code": "malaysian"],
                          ["name" : "Meatballs", "code": "meatballs"],
                          ["name" : "Mediterranean", "code": "mediterranean"],
                          ["name" : "Mexican", "code": "mexican"],
                          ["name" : "Middle Eastern", "code": "mideastern"],
                          ["name" : "Milk Bars", "code": "milkbars"],
                          ["name" : "Modern Australian", "code": "modern_australian"],
                          ["name" : "Modern European", "code": "modern_european"],
                          ["name" : "Mongolian", "code": "mongolian"],
                          ["name" : "Moroccan", "code": "moroccan"],
                          ["name" : "New Zealand", "code": "newzealand"],
                          ["name" : "Night Food", "code": "nightfood"],
                          ["name" : "Norcinerie", "code": "norcinerie"],
                          ["name" : "Open Sandwiches", "code": "opensandwiches"],
                          ["name" : "Oriental", "code": "oriental"],
                          ["name" : "Pakistani", "code": "pakistani"],
                          ["name" : "Parent Cafes", "code": "eltern_cafes"],
                          ["name" : "Parma", "code": "parma"],
                          ["name" : "Persian/Iranian", "code": "persian"],
                          ["name" : "Peruvian", "code": "peruvian"],
                          ["name" : "Pita", "code": "pita"],
                          ["name" : "Pizza", "code": "pizza"],
                          ["name" : "Polish", "code": "polish"],
                          ["name" : "Portuguese", "code": "portuguese"],
                          ["name" : "Potatoes", "code": "potatoes"],
                          ["name" : "Poutineries", "code": "poutineries"],
                          ["name" : "Pub Food", "code": "pubfood"],
                          ["name" : "Rice", "code": "riceshop"],
                          ["name" : "Romanian", "code": "romanian"],
                          ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
                          ["name" : "Rumanian", "code": "rumanian"],
                          ["name" : "Russian", "code": "russian"],
                          ["name" : "Salad", "code": "salad"],
                          ["name" : "Sandwiches", "code": "sandwiches"],
                          ["name" : "Scandinavian", "code": "scandinavian"],
                          ["name" : "Scottish", "code": "scottish"],
                          ["name" : "Seafood", "code": "seafood"],
                          ["name" : "Serbo Croatian", "code": "serbocroatian"],
                          ["name" : "Signature Cuisine", "code": "signature_cuisine"],
                          ["name" : "Singaporean", "code": "singaporean"],
                          ["name" : "Slovakian", "code": "slovakian"],
                          ["name" : "Soul Food", "code": "soulfood"],
                          ["name" : "Soup", "code": "soup"],
                          ["name" : "Southern", "code": "southern"],
                          ["name" : "Spanish", "code": "spanish"],
                          ["name" : "Steakhouses", "code": "steak"],
                          ["name" : "Sushi Bars", "code": "sushi"],
                          ["name" : "Swabian", "code": "swabian"],
                          ["name" : "Swedish", "code": "swedish"],
                          ["name" : "Swiss Food", "code": "swissfood"],
                          ["name" : "Tabernas", "code": "tabernas"],
                          ["name" : "Taiwanese", "code": "taiwanese"],
                          ["name" : "Tapas Bars", "code": "tapas"],
                          ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
                          ["name" : "Tex-Mex", "code": "tex-mex"],
                          ["name" : "Thai", "code": "thai"],
                          ["name" : "Traditional Norwegian", "code": "norwegian"],
                          ["name" : "Traditional Swedish", "code": "traditional_swedish"],
                          ["name" : "Trattorie", "code": "trattorie"],
                          ["name" : "Turkish", "code": "turkish"],
                          ["name" : "Ukrainian", "code": "ukrainian"],
                          ["name" : "Uzbek", "code": "uzbek"],
                          ["name" : "Vegan", "code": "vegan"],
                          ["name" : "Vegetarian", "code": "vegetarian"],
                          ["name" : "Venison", "code": "venison"],
                          ["name" : "Vietnamese", "code": "vietnamese"],
                          ["name" : "Wok", "code": "wok"],
                          ["name" : "Wraps", "code": "wraps"],
                          ["name" : "Yugoslav", "code": "yugoslav"]]
        
        return categoriesDict.map({ (categoryDict) -> Category in
            return Category(categoryDict: categoryDict)
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FiltersViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections[section] == .Categories {
            return self.displayedCategories.count + 1
        }
        if sections[section] == FiltersSections.Deals {
            return 1
        }
        if sections[section] == .Distance {
            if distanceDropDownOpen {
                return distances.count
            }
            else {
                return 1
            }
        }
        if sections[section] == .Sort {
            if sortDropDownOpen {
                return sorts.count
            }
            else {
                return 1
            }
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if sections[indexPath.section] == .Categories {
            if indexPath.row >= self.displayedCategories.count {
                let cell = self.categoriesTableView.dequeueReusableCell(withIdentifier: "ShowMoreCell") as! ShowMoreTableViewCell
                cell.showingAll = showingAllCategories
                return cell
            } else {
                let cell = self.categoriesTableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchTableViewCell
                let category =  displayedCategories[indexPath.row]
                cell.category = category
                cell.isOn = categoryStates[category.code] ?? false
                cell.deal = false
                cell.delegate = self
                return cell
            }
        }
        else if sections[indexPath.section] == FiltersSections.Deals {
            let cell = self.categoriesTableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchTableViewCell
            cell.deal = true
            cell.isOn = self.deal
            cell.delegate = self
            return cell
        }
        else if sections[indexPath.section] == FiltersSections.Distance {
            let cell = self.categoriesTableView.dequeueReusableCell(withIdentifier: "DistanceCell") as! DistanceTableViewCell
            if distanceDropDownOpen {
                cell.distance = self.distances[indexPath.row]
            }
            else {
                cell.distance = self.currentDistance
            }
            return cell
        }
        else if sections[indexPath.section] == FiltersSections.Sort {
            let cell = self.categoriesTableView.dequeueReusableCell(withIdentifier: "SortCell") as! SortTableViewCell
            if sortDropDownOpen {
                cell.sort = self.sorts[indexPath.row]
            }
            else {
                cell.sort = self.sorts[self.currentSortSelectionIndex]
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if sections[indexPath.section] == .Categories {
            if indexPath.row >= self.displayedCategories.count {
                showingAllCategories = !showingAllCategories
                var count = 3
                if showingAllCategories {
                    count = categories.count
                }
                displayedCategories = categories.prefix(count)
            }
        }
        if sections[indexPath.section] == .Distance {
            distanceDropDownOpen = !distanceDropDownOpen
            if !distanceDropDownOpen { // picked a new one
                self.currentDistance = self.distances[indexPath.row]
            }
        }
        if sections[indexPath.section] == FiltersSections.Sort {
            sortDropDownOpen = !sortDropDownOpen
            if !sortDropDownOpen { // picked a new one
                self.currentSortSelectionIndex = indexPath.row
            }
        }
        categoriesTableView.reloadData()
    }
}

extension FiltersViewController: SwitchTableViewCellDelegate {
    func switchTableViewCell(switchTableViewCell: SwitchTableViewCell, didChangeValue value: Bool) {
        if switchTableViewCell.deal {
            print(self.deal, value)
            self.deal = value
        } else {
            self.categoryStates.updateValue(value, forKey: switchTableViewCell.category.code)
        }
        self.categoriesTableView.reloadData()
    }
}
