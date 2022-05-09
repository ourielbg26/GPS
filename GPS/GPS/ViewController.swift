//
//  ViewController.swift
//  GPS
//
//  Created by Ouriel Bennathan on 15/02/2022.
//

import UIKit
import MapKit
class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var myMap: MKMapView!
    var lat:Double?
    var long:Double?
    
    //contient la localisation
    let locationManger = CLLocationManager()
    var myLocation:CLLocation?
    override func viewDidLoad() {
        super.viewDidLoad()
        //veroification des autorisation
        locationManger.requestAlwaysAuthorization()
        locationManger.requestWhenInUseAuthorization()
        //dire ou se trouve les fonction de location manager
        locationManger.delegate = self
        //dire la precision
        locationManger.desiredAccuracy = kCLLocationAccuracyBest
        //si les request son  accepte
        if CLLocationManager.locationServicesEnabled(){
            locationManger.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //avoir la localisation actuelle
        let userLocation:CLLocation = locations.last as! CLLocation
        //si on veut qu'une localisation
        //locationManger.stopUpdatingLocation()
        lat = userLocation.coordinate.latitude
        long = userLocation.coordinate.longitude
        myLocation = locations.last!
        getMapPosition()
        setNameCity()
    }
    fileprivate func getMapPosition(){
        //creer un point avec des coordonne
        let place = CLLocationCoordinate2DMake(lat! , long!)
        //creer une region
        let region = MKCoordinateRegion(center: place, latitudinalMeters: 250, longitudinalMeters: 250)
        myMap.setRegion(region, animated: true)
        showPin(coordinate:place , title: "vous")
    }
    //fonction pour mettre le point sur la localisation
    fileprivate func showPin(coordinate:CLLocationCoordinate2D, title:String){
        let placePin = MKPointAnnotation()
        placePin.coordinate = coordinate
        placePin.title = title
        //envoyer une annotation a la map
        myMap.addAnnotation(placePin)
    }
    @IBAction func mapType(_ sender: UISegmentedControl) {
        setMapType(MKMapType (rawValue: UInt(sender.selectedSegmentIndex)))
    }
    fileprivate func setMapType(_ type:MKMapType?){
        // si il a un type valide
        if let valideType = type {
            myMap.mapType = valideType
        }
    }
    fileprivate func setNameCity(){
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(myLocation!) { placemrks, err in
            if err != nil {return}
            let pm = placemrks?.first
            self.cityNameLabel.text = pm?.locality
        }
    }
}




