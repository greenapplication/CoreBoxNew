//
//  HomeVC.swift
//  CoreBox
//
//  Created by MindLogic Solutions on 26/07/16.
//  Copyright © 2016 com.mls. All rights reserved.
//

import UIKit
import CoreData
class HomeVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    
    var Employee=[NSManagedObject]()
    
    var id :[String] = []
    var name:[String] = []
    var number:[String] = []
    var salary:[String] = []
    var email:[String] = []
    var city:[String] = []
    var imgData:[NSData]=[]
    
    //search code
    var searchname:[String] = []
    var searchnumber:[String] = []
    var searchsalary:[String] = []
    var searchemail:[String] = []
    var searchcity:[String] = []
    var searchimgData:[NSData]=[]
    var searchid :[String] = []
    
    var shouldShowSearchResults = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnAdd.layer.cornerRadius = self.btnAdd.frame.size.width / 2
        self.btnAdd.clipsToBounds = true
        
         self.searchBar.delegate = self
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        DisplayData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonAddEmploye(sender: AnyObject) {
        let signupVC=self.storyboard?.instantiateViewControllerWithIdentifier("AddEmployeVC")as! AddEmployeVC
        navigationController?.pushViewController(signupVC, animated: true)

    }
    
    //MARK- tableviewmethods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if shouldShowSearchResults
        {
            return searchname.count
        }
        
        return name.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        
        if shouldShowSearchResults
        {
            let profileImage = cell.viewWithTag(1)as! UIImageView
            profileImage.image = UIImage(data: searchimgData[indexPath.row])
            
            let lblName = cell.viewWithTag(2) as! UILabel
            lblName.text = searchname[indexPath.row]
            
            let lblEmail = cell.viewWithTag(3) as! UILabel
            lblEmail.text = searchemail[indexPath.row]
            
            let lblcity = cell.viewWithTag(4) as! UILabel
            lblcity.text = "\(searchcity[indexPath.row]) \(searchsalary[indexPath.row]) \(searchnumber[indexPath.row])"
            
        }else{
            let profileImage = cell.viewWithTag(1)as! UIImageView
            profileImage.image = UIImage(data: imgData[indexPath.row])
            
            let lblName = cell.viewWithTag(2) as! UILabel
            lblName.text = name[indexPath.row]
            
            let lblEmail = cell.viewWithTag(3) as! UILabel
            lblEmail.text = email[indexPath.row]
            
            let lblcity = cell.viewWithTag(4) as! UILabel
            lblcity.text = "\(city[indexPath.row]) \(salary[indexPath.row]) \(number[indexPath.row])"
        }
        return cell
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        switch editingStyle {
        case .Delete:
            // remove the deleted item from the model
            let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            let context:NSManagedObjectContext = appDel.managedObjectContext
            context.deleteObject(Employee[indexPath.row] as NSManagedObject)
            
            name.removeAtIndex(indexPath.row)
            number.removeAtIndex(indexPath.row)
            salary.removeAtIndex(indexPath.row)
            city.removeAtIndex(indexPath.row)
            email.removeAtIndex(indexPath.row)
            imgData.removeAtIndex(indexPath.row)
            
            do {
                try context.save()
            } catch _ {
            }
            
            // remove the deleted item from the `UITableView`
            tblView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        default:
            return
            
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let nextVC = self.storyboard?.instantiateViewControllerWithIdentifier("EditEmployeVC")as! EditEmployeVC
        
        if shouldShowSearchResults
        {
            nextVC.name=searchname[indexPath.row]
            nextVC.number=searchnumber[indexPath.row]
            nextVC.email=searchemail[indexPath.row]
            nextVC.city=searchcity[indexPath.row]
            nextVC.salary=searchsalary[indexPath.row]
            nextVC.photo=searchimgData[indexPath.row]
            nextVC.id=searchid[indexPath.row]

        }else{
            nextVC.name=name[indexPath.row]
            nextVC.number=number[indexPath.row]
            nextVC.email=email[indexPath.row]
            nextVC.city=city[indexPath.row]
            nextVC.salary=salary[indexPath.row]
            nextVC.photo=imgData[indexPath.row]
            nextVC.id=id[indexPath.row]
        }
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        
        if searchBar.text!.isEmpty{
            shouldShowSearchResults = false
            tblView.reloadData()
        } else {
            shouldShowSearchResults = true
            removeAllSearchArray()
            
            for i in 0..<name.count
            {
                let name = self.name[i]
                
                if name.lowercaseString.rangeOfString(searchText.lowercaseString)  != nil
                {
                    searchname.append(self.name[i])
                    searchemail.append(self.email[i])
                    searchnumber.append(self.number[i])
                    searchsalary.append(self.salary[i])
                    searchcity.append(self.city[i])
                    searchimgData.append(self.imgData[i])
                    searchid.append(self.id[i])
                }
            }
            
            tblView.reloadData()
        }
    }
    
    func removeAllSearchArray()
    {
        if !searchimgData.isEmpty
        {
            searchimgData.removeAll(keepCapacity: true)
        }
        if !searchcity.isEmpty
        {
            searchcity.removeAll(keepCapacity: true)
        }
        if !searchsalary.isEmpty
        {
            searchsalary.removeAll(keepCapacity: true)
        }
        if !searchname.isEmpty
        {
            searchname.removeAll(keepCapacity: true)
        }
        if !searchnumber.isEmpty
        {
            searchnumber.removeAll(keepCapacity: true)
        }
        if !searchemail.isEmpty
        {
            searchemail.removeAll(keepCapacity: true)
        }
        if !searchid.isEmpty
        {
            searchid.removeAll(keepCapacity: true)
        }
    }


    func DisplayData(){
        
        //hides keyboard if it open
        view.endEditing(true)
        
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as? AppDelegate
        
        let managedContext = appDelegate?.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"EmployeData")
        
        do
        {
            let fetchedResults =  try managedContext!.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults
            {
                Employee = results
            }
        }
        catch _ {
            print("Could not fetch")
            
        }
        
        if !id.isEmpty
        {
            id.removeAll(keepCapacity: true)
        }
        if !name.isEmpty
        {
            name.removeAll(keepCapacity: true)
        }
        if !number.isEmpty
        {
            number.removeAll(keepCapacity: true)
        }
        if !salary.isEmpty
        {
            salary.removeAll(keepCapacity: true)
        }
        if !email.isEmpty
        {
            email.removeAll(keepCapacity: true)
        }
        if !city.isEmpty
        {
            city.removeAll(keepCapacity: true)
        }
        if !imgData.isEmpty
        {
            imgData.removeAll(keepCapacity: true)
        }
        
        for i in 0..<Employee.count
        {
            let alMsg = Employee[i]

            id.append(alMsg.valueForKey("id") as! String)
            name.append(alMsg.valueForKey("name") as! String)
            number.append(alMsg.valueForKey("number") as! String)
            salary.append(alMsg.valueForKey("salary") as! String)
            email.append(alMsg.valueForKey("email") as! String)
            city.append(alMsg.valueForKey("city") as! String)
            imgData.append(alMsg.valueForKey("profile") as! NSData)
            
        }
        tblView.reloadData()
    }
    
}
