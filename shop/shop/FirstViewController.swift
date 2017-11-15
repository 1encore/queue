//
//  FirstViewController.swift
//  shop
//
//  Created by Beisenbek Yerbolat on 11/15/17.
//  Copyright © 2017 Beisenbek Yerbolat. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var products = [Item]()
    var cart = [Int]()
    
    @IBAction func addToCart(_ sender: Any) {
        let buttonPosition:CGPoint = (sender as AnyObject).convert(CGPoint.zero, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)!
        cart.append(indexPath.row)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        getItems(query: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getItems(query: String) {
        let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = "https://hg1zadr.000webhostapp.com/api.php?q=\(query)"
        
        
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            if(error != nil) {
                print(error?.localizedDescription)
            }else{
                let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: AnyObject]
                
                if let items = json["items"] as? [[String: AnyObject]] {
                    print("got items", items)
                    
                    self.products = []
                    for temp in items{
                        let object = Item()
                        object.id = temp["id"] as? Int
                        object.descr = temp["descr"] as? String
                        object.title = temp["name"] as? String
                        object.price = temp["price"] as? String
                        object.image = temp["url"] as? String
                        self.products.append(object)
                    }
                    
                    print(self.products)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
            }.resume()
        
    }
}

extension FirstViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text
        print(text)
        self.getItems(query: text!)
        self.tableView.reloadData()
    }
}

extension FirstViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        
        cell.itemTitle.text = products[indexPath.row].title!
        cell.itemDescr.text = products[indexPath.row].descr!
        cell.itemPrice.text = products[indexPath.row].price! + " KZT"
        var imgUrl = "https://hg1zadr.000webhostapp.com/img/"
        imgUrl += products[indexPath.row].image!
        cell.itemImage.ImageFromUrl(urlString: imgUrl)
        
        cell.layoutIfNeeded()
        return cell
    }
}

extension UIImageView {
    public func ImageFromUrl(urlString: String) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if(error != nil){
                    print(error?.localizedDescription)
                }else{
                    if let image = UIImage(data: data!) {
                        DispatchQueue.main.async {
                            self.image = image
                        }
                    }
                }
            }).resume()
        }
    }
}
