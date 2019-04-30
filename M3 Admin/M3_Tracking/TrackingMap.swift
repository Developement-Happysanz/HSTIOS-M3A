//
//  TrackingMap.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 02/03/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import CoreLocation

class TrackingMap: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate
{
    
    var Latitude = [String]()
    
    var Longitude = [String]()
    
    let locationManager = CLLocationManager()
    
    var userLive_Latitude : Double?
    
    var userLive_Longitude : Double?
    
    var lat = ""
    
    var long = ""
    
    var livelocTimer: Timer!
    
    var coordinateArray: [CLLocationCoordinate2D] = []
    
    var coords = [CLLocation]()
    
    var strDistance = "NO"
    
    @IBOutlet var distanceLabel: UILabel!
    
    @IBOutlet var distanceModeview: UIView!
    
    @IBOutlet var mapView: MKMapView!
    
    @IBAction func stopButton(_ sender: Any)
    {
        self.locationManager.stopUpdatingLocation()
        let str = UserDefaults.standard.string(forKey: "tracking_View")
        if str == "live"
        {
            livelocTimer.invalidate()
        }
        self.performSegue(withIdentifier: "backPage", sender: self)
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Tracking"
        
        NavigationBarTitleColor.navbar_TitleColor
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
        
        let str = UserDefaults.standard.string(forKey: "tracking_View")
        
        if str == "live"
        {
            webRequestLiveLocation ()
            
            livelocTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(webRequestLiveLocation), userInfo: nil, repeats: true)
            
            self.distanceModeview.isHidden = true
        }
        else
        {
           webRequestDistancelocation ()
            
           self.distanceModeview.isHidden = false

        }
        
        navigationLeftButton ()

    }
    
    func navigationLeftButton ()
    {
        let str = UserDefaults.standard.string(forKey: "fromDashboard")
        
        if str == "YES"
        {
            let navigationLeftButton = UIButton(type: .custom)
            navigationLeftButton.setImage(UIImage(named: "back-01"), for: .normal)
            navigationLeftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            navigationLeftButton.addTarget(self, action: #selector(menuButtonclick), for: .touchUpInside)
            let navigationButton = UIBarButtonItem(customView: navigationLeftButton)
            self.navigationItem.setLeftBarButton(navigationButton, animated: true)
        }
    }
    
    @objc func menuButtonclick()
    {
        let str = UserDefaults.standard.string(forKey: "fromDashboard")
        
        if str == "YES"
        {
            self.performSegue(withIdentifier: "backPage", sender: self)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKPolyline.self) {
            // draw the track
            let polyLine = overlay
            let polyLineRenderer = MKPolylineRenderer(overlay: polyLine)
            polyLineRenderer.strokeColor = UIColor.blue
            polyLineRenderer.lineWidth = 3.0
            
            _ = MKCoordinateSpan(latitudeDelta: 0.050, longitudeDelta: 0.050)
            
            return polyLineRenderer
        }
        
        return MKPolylineRenderer()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        let str = UserDefaults.standard.string(forKey: "tracking_View")
        
        if str == "live"
        {
            livelocTimer.invalidate()
        }
        else
        {
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        userLive_Latitude = Double(lat)
        userLive_Longitude = Double(long)
    
        let myLocation = CLLocation(latitude: userLive_Latitude!, longitude: userLive_Longitude!)
        
        let myLoc = myLocation.coordinate

        mapView.mapType = MKMapType.standard
        
        let latDelta:CLLocationDegrees = 0.050
        let lonDelta:CLLocationDegrees = 0.050
        
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let region = MKCoordinateRegion(center: myLoc, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = myLoc
        annotation.title = GlobalVariables.track_name
        annotation.subtitle = "current location"
        mapView.addAnnotation(annotation)
        
    }
    
    @objc func webRequestLiveLocation ()
    {
        
        let functionName = "apipia/user_tracking_current"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["track_date": GlobalVariables.track_date!, "mob_id": GlobalVariables.track_mob_id!]
        Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
            {
                response in
                switch response.result
                {
                case .success:
                    print(response)
                    let JSON = response.result.value as? [String: Any]
                    let msg = JSON?["msg"] as? String
                    let status = JSON?["status"] as? String
                    if (status == "success")
                    {
                        var trackingDetails = JSON?["trackingDetails"] as? [Any]
                        for i in 0..<(trackingDetails?.count ?? 0)
                        {
                            var dict = trackingDetails?[i] as? [AnyHashable : Any]
                            self.lat = dict?["Latitude"] as! String
                            self.long = dict?["Longitude"] as! String
                        }
                        
                            self.locationManager.startUpdatingLocation()
                    }
                    else
                    {
                        let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                            self.livelocTimer.invalidate()
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    break
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func webRequestDistancelocation ()
    {
    
        let functionName = "apipia/user_tracking"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["track_date": GlobalVariables.track_date!, "mob_id": GlobalVariables.track_mob_id!]
        Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
            {
                response in
                switch response.result
                {
                case .success:
                    print(response)
                    let JSON = response.result.value as? [String: Any]
                    let msg = JSON?["msg"] as? String
                    let status = JSON?["status"] as? String
                    if (status == "success")
                    {
                        var trackingDetails = JSON?["trackingDetails"] as? [Any]
                        
                        var Distance = JSON?["Distance"] as? [Any]
                        
                        for i in 0..<(Distance?.count ?? 0)
                        {
                            var dict = Distance?[i] as? [AnyHashable : Any]
                         //   let distance = dict?["distance"] as? String
                            let km = dict?["km"] as? String
                            
                            self.distanceLabel.text  = String(format: "%@ %@","Distance Travelled : ", km!.prefix(5) as CVarArg)
                            
                            print(self.distanceLabel.text as Any)
                            
                        }
                        for i in 0..<(trackingDetails?.count ?? 0)
                        {
                            var dict = trackingDetails?[i] as? [AnyHashable : Any]
                            
                            
                            let _Latitude = dict?["Latitude"] as? String
                            let _Longitude = dict?["Longitude"] as? String
                            
                            self.Latitude.append(_Latitude ?? "")
                            self.Longitude.append(_Longitude ?? "")
                            
                        }
                        
                        if self.Latitude.count == self.Longitude.count
                        {
                            for i in 0..<(self.Latitude.count)
                            {
                                let lat = Double(self.Latitude[i])
                                let long = Double(self.Longitude[i])
                                
                                let coordinatesToAppend = CLLocation(latitude: lat!, longitude: long!)
                                self.coords.append(coordinatesToAppend)
                                
                            }
                            
                        }
                        
                        let firstPinLat: String =  self.Latitude.first!
                        let firstPinLon: String =  self.Longitude.first!
                        
                        let secPinLat: String =  self.Latitude.last!
                        let secPinLon: String =  self.Longitude.last!

                        let latitudeFirst:CLLocationDegrees = Double(firstPinLat)!
                        let longitudeFirst:CLLocationDegrees = Double(firstPinLon)!
                        
                        let latitudeSecond:CLLocationDegrees = Double(secPinLat)!
                        let longitudeSecond:CLLocationDegrees = Double(secPinLon)!
                        
                        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitudeFirst, longitudeFirst)
                        
                        let locationSec:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitudeSecond, longitudeSecond)

                        let fstannotation = MKPointAnnotation()
                        let secannotation = MKPointAnnotation()
                        let firstCoordinate = location
                        let secondCoordinate = locationSec
                        fstannotation.coordinate = firstCoordinate
                        secannotation.coordinate = secondCoordinate
                        
                        self.mapView.addAnnotation(fstannotation)
                        self.mapView.addAnnotation(secannotation)

                        self.mapView.region = MKCoordinateRegion(center: self.coords[0].coordinate, span: MKCoordinateSpan(latitudeDelta: 0.050, longitudeDelta: 0.050))
                        var coordinates = self.coords.map({(location: CLLocation!) -> CLLocationCoordinate2D in return location.coordinate})
                        let polyline = MKPolyline(coordinates: &coordinates, count: self.coords.count)
                        self.mapView.addOverlay(polyline)
                    }
                    else
                    {
                        let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    break
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        guard !(annotation is MKUserLocation) else { return nil }

        let str = UserDefaults.standard.string(forKey: "tracking_View")
        
        if str == "live"
        {
            let identifier = "com.domain.app.something"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            if annotationView == nil
            {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.pinTintColor = UIColor.green
                annotationView?.canShowCallout = true
            }
            
             return annotationView
        }
        else
        {
            let identifier = "com.domain.app.something"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            if annotationView == nil
            {
                if strDistance == "NO"
                {
                    annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    annotationView?.pinTintColor = UIColor.green
                    annotationView?.canShowCallout = true
                    strDistance = "YES"
                }
                else
                {
                    annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    annotationView?.pinTintColor = UIColor.red
                    annotationView?.canShowCallout = true
                    strDistance = "NO"
                }
                
            }
            else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
    }
}
