//
//  MapViewVC.swift
//  GoogleMapsIntegration
//
//  Created by Kalpesh Thakare on 02/02/17.
//  Copyright © 2017 Kalpesh Thakare. All rights reserved.
//

import UIKit
import GoogleMaps // Import Google Maps To Use map
import GooglePlaces // Import Google Places to Access Places


protocol AreaDetailsProtocol // Protocol Created to pass Street Name And Area Name
{
    func GetStreetAndAreaName(StreetName:String, AreaName:String) -> Void
}



class MapViewVC: UIViewController,GMSMapViewDelegate,UITextFieldDelegate,GMSAutocompleteViewControllerDelegate,CLLocationManagerDelegate {
    
    // Delegate Variable
    
    var delegate: AreaDetailsProtocol?
    
    
    var placesClient: GMSPlacesClient!
    
    
    @IBOutlet weak var txtSearchPlace: UITextField!
    
    // LOCATION
    var locationManager = CLLocationManager()
    
    var latitude = Double()
    var longitude = Double()
    
    
    // Location View Properties
    
    @IBOutlet weak var viewLocation: UIView!
    
    @IBOutlet weak var lblStreetName: UILabel!
    
    @IBOutlet weak var lblAreaName: UILabel!
    
    //
    
    
    @IBOutlet weak var btnSearchForPlace: UIButton!
    
    var marker = GMSMarker() // To Show Marker
    
    var geoCoder = CLGeocoder()// to Acces Cordinates
    
    @IBOutlet weak var myMapView: GMSMapView! // Set Self View as GMSMapView
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewLocation.isHidden = true // Set Location Information View Hidden
        
        myMapView.delegate = self
        txtSearchPlace.delegate = self
        placesClient = GMSPlacesClient.shared()
        
        // Before Calling Location Manager First Check for Internet Connection
        
        // if (there is internet Connection)
        callCLLocationManager()

        // else show there is no internet Connection
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D)
    {
        
//        print("Hi Kalpesh Thakare long pressed happen!")
        
        marker = GMSMarker() // Initialize marker when Long Presed
        
        // Set marker Position Obtained From cordinates where long pressed is happen
        marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        // set marker to our Map View
        marker.map = self.myMapView
        
        let location:CLLocation = CLLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
        print(location)
        
        // REVERSE GEO CODER is used to fetch the address from longitude and latitude
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Address dictionary
            print(placeMark.addressDictionary!)
            
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                print(locationName)
                
                self.lblStreetName.text = locationName as String
                self.marker.title = locationName as String
            }
            
            // Zip code
            if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
                print(zip)
            }
            
            // Street address
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                print(street)
                
                
                self.lblStreetName.text = street as String
                self.marker.title = street as String
            }
            
            // Sub Locality
            if let subLocality = placeMark.addressDictionary!["SubLocality"] as? NSString {
                print(subLocality)
                let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString
                
                if(street == nil)
                {
                    self.lblStreetName.text = "\(subLocality as String)"
                    self.marker.title = subLocality as String
                }
                else
                {
                    self.lblStreetName.text = "\(street!), \(subLocality as String)"
                    self.marker.title = "\(street!), \(subLocality as String)"
                    
                }
            }
            
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? NSString {
                print(country)
                
                self.lblAreaName.text = country as String
                self.marker.snippet = country as String
            }
            
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                print(city)
                
                
                self.lblAreaName.text = city as String
                self.marker.snippet = city as String
            }
            
            
            if(self.lblStreetName.text == "" || self.lblAreaName.text == "" )
            {
                self.marker.map = nil
                
                self.myMapView.isUserInteractionEnabled = true
                
                self.txtSearchPlace.isUserInteractionEnabled = true
                self.btnSearchForPlace.isUserInteractionEnabled = true
                
            }
            else
            {
                self.viewLocation.isHidden = false
                
                self.myMapView.isUserInteractionEnabled = false
                
                self.txtSearchPlace.isUserInteractionEnabled = false
                self.btnSearchForPlace.isUserInteractionEnabled = false
                
                
                self.longitude = coordinate.longitude
                self.latitude = coordinate.latitude
                print(self.longitude); print(self.latitude)
                
                
            }
        })
        
    }
    
    
    func callCLLocationManager() -> Void // call CLLocation manager method to get current Position
    {
        locationManager = CLLocationManager()
        
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        locationManager.stopUpdatingLocation()
        
        latitude = locations.last!.coordinate.latitude
        longitude = locations.last!.coordinate.longitude
        
        displayUserLocation()
        
    }
    
    
    func displayUserLocation() -> Void
    {
        
        myMapView.isMyLocationEnabled = true
        
        myMapView.settings.myLocationButton = true
        

        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15)
        
        
        print(self.longitude); print(self.latitude)
        
        self.myMapView.camera = camera

        
    }
    
    @IBAction func btnShowStreetView(_ sender: UIButton)
    {
        let StreetViewVC = (self.storyboard?.instantiateViewController(withIdentifier: "StreetViewVC"))! as UIViewController
        mapViewcoordinate = marker.position
        self.present(StreetViewVC, animated: true, completion: nil)
    }
    
    @IBAction func btnCancel(_ sender: UIButton)
    {
        // remove previous Marker
        marker.map = nil
        
        viewLocation.isHidden = true
        myMapView.isUserInteractionEnabled = true
        
        self.txtSearchPlace.isUserInteractionEnabled = true
        self.btnSearchForPlace.isUserInteractionEnabled = true
        
        
        lblStreetName.text = "" // set Text to "" before loading it Again
        lblAreaName.text = ""
        
    }
    
    @IBAction func btnAccept(_ sender: UIButton)
    {
        
        delegate?.GetStreetAndAreaName(StreetName: lblStreetName.text!, AreaName: lblAreaName.text!)
        
        _ = self.navigationController?.popViewController(animated: true)
        
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        googleFindPlace()
        
        txtSearchPlace.resignFirstResponder()
        
    }
    
    @IBAction func btnSearchForPlace(_ sender: UIButton)
    {
        googleFindPlace()
    }
    
    func googleFindPlace() -> Void
    {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        self.present(autoCompleteController, animated: false, completion: nil)
    }
    
    
    // MARK: Google AutoComplete Delegate
    
    
    func  viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace)
    {
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 15)
        
        myMapView.camera = camera
        
        self.dismiss(animated: false, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error)
    {
        print("AutoComplete Error:  \(error)")
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController)
    {
        self.dismiss(animated: false, completion: nil)
    }
}
