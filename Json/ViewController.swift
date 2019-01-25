//
//  ViewController.swift
//  Json
//
//  Created by Student-001 on 11/12/18.
//  Copyright © 2018 ra. All rights reserved.
//

import UIKit
//http://api.github.com/repositories/19438/commits
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var tblvwshodata: UITableView!
    var nameArray: [String] = [String]()
    var nameArray1: [String] = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1 , reuseIdentifier: "cell")
        cell.textLabel?.text = nameArray[indexPath.row]
        cell.detailTextLabel?.text = nameArray1[indexPath.row]
        return cell
    }
    
    
    
    
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlstr = "http://api.github.com/repositories/19438/commits"
        parseJson(urlString: urlstr)
        tblvwshodata.dataSource = self
        tblvwshodata.delegate = self
        if (nameArray.count>0)
        {
            tblvwshodata.reloadData()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func parseJson(urlString: String)
    {
        nameArray = [String]()
        nameArray1 = [String]()
        enum jsonError : String,Error
        {
            case responseError = "Response not found"
            case dataError = "Data not fiound"
            case conversionError = "Conversion failed"
        }
        guard let endPoint = URL(string: urlString)
        else
        {
            print("End point not found")
            return
        }
        URLSession.shared.dataTask(with: endPoint){(data, response, error) in
            do
            {
            guard let response1 = response
            else
            {
                throw jsonError.responseError
            }
            print(response1)
            guard let data = data
            
                else
                {
                    throw jsonError.dataError
                }
            let firstArray : [[String:Any]] = try
            JSONSerialization.jsonObject(with: data, options: []) as!
            [[String : Any]]
                
                for item in firstArray
                {
                    let commitDic:[String:Any] = item["commit"] as! [String: Any]
                    let authorDic:[String:Any] = commitDic["author"] as! [String:Any]
                    let name: String = authorDic["name"]as! String
                    self.nameArray.append(name)
                    let parentDic:[[String:Any]]  = item["parents"]as! [[String:Any]]
                    for item1 in parentDic
                    {
                        let url: String = item1["url"]as! String
                        self.nameArray1.append(url)
                    }
                }
                print(self.nameArray)
                print(self.nameArray1)
                self.tblvwshodata.reloadData()
        }
        catch let error as jsonError
        {
                print(error.rawValue)
            }
            catch let error as NSError
            {
               print(error.localizedDescription)
            }
        
            }.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

