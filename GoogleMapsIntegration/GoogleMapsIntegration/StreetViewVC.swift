//
//  StreetViewVC.swift
//  GoogleMapsIntegration
//
//  Created by Kalpesh Thakare on 02/02/17.
//  Copyright © 2017 Kalpesh Thakare. All rights reserved.
//

import UIKit
import GoogleMaps // Import Google Map for Accessing Street View


var mapViewcoordinate = CLLocationCoordinate2D() // Need Cordinates For Showing Street View For That Place.


class StreetViewVC: UIViewController {
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        
        let service = GMSPanoramaService() // We get Street View in a PANORAMA OBJECT
        
        // Set Panorama Cordinates Which we Got from Marker
        service.requestPanoramaNearCoordinate(mapViewcoordinate, callback: {panorama,error in
            
            
            if(panorama != nil) // If returned Object is not nil then handle it
            {
                let camera:GMSPanoramaCamera = GMSPanoramaCamera.init(heading: 180, pitch: 0, zoom: 1, fov: 90)
                
                let panoView = GMSPanoramaView()
                
                panoView.camera = camera
                panoView.panorama = panorama
                
                self.view = panoView
                
                // Created a Button Programatically to Close the Street View
                let closeButton = UIButton(frame: CGRect(x: 10, y: 20, width: 80, height: 50))
                closeButton.backgroundColor = .white
                closeButton.setTitleColor(UIColor.black, for: .normal)
                closeButton.setTitle("Close", for: .normal)
                closeButton.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
                
                self.view.addSubview(closeButton)
                
                
            }
            else // ifreturn Object is nil then handle it OR show message Street view is not available and Dissmiss the View Controller
            {
                
                let alert = UIAlertController(title: "Message", message: "Street view is not available for this area", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
            }
            
            
        }
        )
    }
    
    @objc func buttonAction(sender: UIButton!)
    {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
