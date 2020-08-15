//
//  ViewController.swift
//  Task
//
//  Created by Rohini Deo on 15/08/20.
//  Copyright © 2020 Taxgenie. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

struct JsonStruct:Decodable {
    var main : WeatherDetails
}

struct WeatherDetails : Decodable{
    let temp : Double?
    let feels_like : Double?
    let temp_min : Double?
    let temp_max : Double?
    let pressure : Int?
    let humidity: Int?
}

class ViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    let pin = MKPointAnnotation()
    var locationManager = CLLocationManager()
    var lat = 19.2074
    var long = 73.1578
    var isDoubleTap = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.isZoomEnabled = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedGesture))
        tapGesture.numberOfTapsRequired = 2
        mapView.addGestureRecognizer(tapGesture)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @objc func tappedGesture(sender: UIGestureRecognizer){
        self.isDoubleTap = true
        let locationInView = sender.location(in: mapView)
        let coordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)
        self.pin.coordinate = coordinate
        mapView.addAnnotation(pin)
        self.lat = coordinate.latitude
        self.long = coordinate.longitude
        self.getData()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            locationManager.stopUpdatingLocation()
            let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            mapView.setRegion(region, animated: true)
            pin.coordinate = coordinate
            mapView.addAnnotation(pin)
            self.lat = location.coordinate.latitude
            self.long = location.coordinate.longitude
            self.getData()
        }
    }
    
    func getData(){
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(self.lat)&lon=\(self.long)&%20units=metric&appid=a4a161767cc143f9499b3bea6efc88cd")
        
        URLSession.shared.dataTask(with: url!){ (data,response,error) in
            do{
                if error == nil{
                    let arrData = try JSONDecoder().decode(JsonStruct.self, from: data!)
                    DispatchQueue.main.async {
                        if self.isDoubleTap{
                            let detail = self.storyboard?.instantiateViewController(identifier: "DetailsVC") as! DetailsVC
                            detail.strTemp = "\(arrData.main.temp ?? 0.0)"
                            detail.strHumidity = "\(arrData.main.humidity ?? 0)"
                            detail.strLat = "\(self.lat)"
                            detail.strLong = "\(self.long)"
                            self.navigationController?.pushViewController(detail, animated: true)
                        }
                        if let temp = arrData.main.temp{
                            self.pin.title = "Temperature - \(temp)" + ""
                        }
                    }
                }
            }catch(let error){
                print(error.localizedDescription)
            }
        }.resume()
        
    }
}
    
