//
//  EditEmployeVC.swift
//  CoreBox
//
//  Created by MindLogic Solutions on 26/07/16.
//  Copyright © 2016 com.mls. All rights reserved.
//

import UIKit
import CoreData

class EditEmployeVC: UIViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var txtname: UITextField!
    @IBOutlet weak var txtNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtSalary: UITextField!
    
    
    var name:String=""
    var number:String=""
    var email:String=""
    var city:String=""
    var salary:String=""
    var photo:NSData=NSData()
    
    var id :String = ""
    
    
    var Employee=[NSManagedObject]()
    var imgData:NSData=NSData()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        txtname.text=name
        txtNumber.text=number
        txtEmail.text=email
        txtCity.text=city
        txtSalary.text=salary
        profileImg.image=UIImage(data: photo)
        imgData = photo

        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EditEmployeVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonSelectImage(sender: AnyObject) {
        self.view.endEditing(true)
        let actionSheet = UIActionSheet(title:nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take Photo", "Choose Photo")
        
        actionSheet.showInView(self.view)

    }

    @IBAction func buttonUpdate(sender: AnyObject) {
        
        //1
        let appDelegate =
            UIApplication.sharedApplication().delegate as? AppDelegate
        
        let managedContext = appDelegate?.managedObjectContext
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"EmployeData")
        
        fetchRequest.predicate = NSPredicate(format: "id = %@", "\(id)")
        do
        {
            let fetchedResults =  try managedContext!.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults
            {
                if results.count > 0
                {
                    
                    for i in 0..<results.count
                    {
                        let managedObject = results[i]
                        
                        managedObject.setValue(txtname.text, forKey: "name")
                        managedObject.setValue(txtNumber.text, forKey: "number")
                        managedObject.setValue(txtCity.text, forKey: "city")
                        managedObject.setValue(txtEmail.text, forKey: "email")
                        managedObject.setValue(imgData, forKey: "profile")
                        managedObject.setValue(txtSalary.text, forKey: "salary")
                    }
                    
                    do
                    {
                        try managedContext?.save()
                        navigationController?.popViewControllerAnimated(true)
                    }
                    catch {}
                }
            }
            
        }
        catch _ {
            print("Could not update")
            
        }
        
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int)
    {
        
        switch (buttonIndex){
            
        case 1:
            if !UIImagePickerController.isSourceTypeAvailable(.Camera) {
                let deviceNotFoundAlert: UIAlertView = UIAlertView(title: "No Device", message: "Camera is not available", delegate: nil, cancelButtonTitle: nil, otherButtonTitles:"Okay")
                deviceNotFoundAlert.show()
            }
            else {
                let picker: UIImagePickerController = UIImagePickerController()
                picker.delegate = self
                picker.allowsEditing = true
                picker.sourceType = .Camera
                self.presentViewController(picker, animated: true, completion: { _ in })
            }
        case 2:
            let picker: UIImagePickerController = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .PhotoLibrary
            self.presentViewController(picker, animated: true, completion: { _ in })
        default:
            print("Default")
            //Some code here..
            
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            self.profileImg.image = pickedImage
            //conver selected image to nsdata
            if imgData != ""
            {
                imgData=NSData()
            }
            imgData = UIImageJPEGRepresentation(pickedImage, 1.0)!
            
        }
        dismissViewControllerAnimated(false, completion: nil)
        
    }

}
