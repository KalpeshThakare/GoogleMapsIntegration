//
//  GetDetailsController.swift
//  GoogleMapsIntegration
//
//  Created by Kalpesh Thakare on 02/02/17.
//  Copyright © 2017 Kalpesh Thakare. All rights reserved.
//

import UIKit

class GetDetailsController: UIViewController,AreaDetailsProtocol {

    
    // PROPERTIES
    
    @IBOutlet weak var lblStreetName: UILabel!  // Show Street Name of Selected Location
    
    @IBOutlet weak var lblAreaName: UILabel!  // Show Area Name of Selected Location
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // ACTIONS
    
    
    @IBAction func btnSelectPlace(_ sender: UIButton) // Select Action to Select the Place
    {
        let MapViewVC = (self.storyboard?.instantiateViewController(withIdentifier: "MapViewVC")) as! MapViewVC // Push Map View Controller
        
        MapViewVC.delegate = self //  Set Delegate to Self
        
        self.navigationController?.pushViewController(MapViewVC, animated: true)
    }
    
    
    func GetStreetAndAreaName(StreetName: String, AreaName: String)  //  Delegate Method Of Map View Controller
    {
        lblStreetName.text = StreetName // Set Street name to Street Label
        
        lblAreaName.text = AreaName //  Set Area name to Area Label
    }
    
    
}
