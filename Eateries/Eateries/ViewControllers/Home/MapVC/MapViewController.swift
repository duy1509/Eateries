//
//  MapViewController.swift
//  Eateries
//
//  Created by DUY on 12/6/17.
//  Copyright © 2017 duyhandsome. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import Kingfisher
import Firebase
import ProgressHUD
import Alamofire
import SwiftyJSON

class MapViewController: UIViewController {
    @IBOutlet weak var viewGoogleMap: UIView!
    fileprivate var mapView:GMSMapView?
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    let auth = Auth.auth()
    let ref = Database.database().reference()
    let storage = Storage.storage().reference(forURL: "gs://eateries-eae99.appspot.com/")
    fileprivate var infoPost:[Post] = []
    fileprivate var eateriesLocation:CLLocationCoordinate2D!
    fileprivate var autocompleteController:GMSAutocompleteViewController?
    lazy var searchBar:UISearchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 150, height: 20))
    fileprivate var post:Post?
    let locationManager = CLLocationManager()
    fileprivate var userLocation:CLLocationCoordinate2D?
    var postDirection:Post?
    var isDirection = false
    
    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupNavi()
        getUserLocation()
        setupGoogleMap()
        setupUI()
    }
    
    
    //MARK:- Support functions
    
    func setupUI(){
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    private func setupNavi(){
        navigationController?.navigationBar.tintColor = .white
        let backBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        backBtn.setImage(#imageLiteral(resourceName: "arrowLeftSimpleLineIcons"), for: .normal)
        backBtn.addTarget(self, action: #selector(MapViewController.backView), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func setupSearchBar() {
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.placeholder = "Search"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.delegate = self
        if let textSearch = searchBar.value(forKey: "_searchField") as? UITextField {
            textSearch.layer.cornerRadius = 10
            textSearch.clipsToBounds = true
        }
        navigationItem.titleView = searchBar
    }
    
    func getUserLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //MARK:- Action buttons
    
    @objc func backView() {
        navigationController?.popViewController(animated: true)
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("COORDINATE \(coordinate)") // when you tapped coordinate
    }
    
    //MARK:- Firebase Functions
    
    func upLoadData(){
        Firebase.shared.getDataPost(TableName.Table, .childAdded) { [weak self] (userPost, key, error) in
            guard let strongSelf = self else { return }
            if error == nil {
                guard let userPost = userPost else { return }
                userPost.location = CLLocationCoordinate2D(latitude: userPost.latitude!, longitude: userPost.longitude!)
                strongSelf.infoPost.append(userPost)
                strongSelf.addMarker()
            } else {
                ProgressHUD.showError(error)
            }
        }
    }
    
}
//MARK:- Setup Google Map

extension MapViewController:GMSMapViewDelegate,CLLocationManagerDelegate{
    
    func setupGoogleMap(){
        _ = infoPost
        mapView = GMSMapView(frame: CGRect(x: 0, y: 0, width: self.viewGoogleMap.frame.size.width, height: self.viewGoogleMap.frame.size.height))
        mapView?.mapType = .terrain
        mapView?.isMyLocationEnabled = true
        mapView?.settings.myLocationButton = true
        mapView?.delegate = self
        DispatchQueue.main.async {
            self.viewGoogleMap.insertSubview(self.mapView!, at: 0)
        }
    }
    
    func addMarker() {
        //    Creates a marker in the center of the map.
        for i in infoPost {
            let marker = GMSMarker(position: i.location!)
            marker.icon = UIImage(named: "iconLocationMap")
            marker.userData = i
            marker.map = mapView
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        if let location: CLLocation = locations.last {
            userLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            if isDirection == false {
                upLoadData()
                let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 16)
                mapView?.animate(to: camera)
            } else {
                getDirection()
                guard let postDirection = postDirection else { return }
                guard let position = postDirection.location else { return }
                let marker = GMSMarker(position: position)
                marker.userData = postDirection
                marker.map = mapView
                marker.icon = UIImage(named: "iconLocationMap")
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")

    }

    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let infoWindow = Bundle.main.loadNibNamed("InfoWinDow", owner: self.viewGoogleMap, options: nil)?.first as? InfoWinDowView
        if let des = marker.userData as? Post {
            infoWindow?.lblName.text = des.nameEateries
            if let urlString = des.urlImage {
                let url = URL(string: urlString)
                infoWindow?.imgHinh.kf.setImage(with: url)
            }
            infoWindow?.lblLocation.text = des.address
        }
        
        return infoWindow
    }
}

// MARK: - Google Map Direction
extension MapViewController {
    
    fileprivate func getDirection() {
        guard let postDirection = postDirection?.location, let userLocation = userLocation else { return }
        let urlString = "\(Constants.urlDirecton)?origin=\(userLocation.latitude),\(userLocation.longitude)&destination=\(postDirection.latitude),\(postDirection.longitude)&mode=driving&key=\(Constants.googleAPIKey)"
        let _header: HTTPHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        NetworkService.requestWith(.get, url: urlString, parameters: nil, header: _header) { [weak self] (data, error, code) in
            guard let strongSelf = self else { return }
            if error == nil {
                guard let data = data else { return }
                let dataJSON = JSON(data)
                if let routes = dataJSON["routes"].array {
                    if let route = routes.first {
                        if let overView = route["overview_polyline"].dictionaryObject {
                            guard let point = overView["points"] as? String else { return }
                            let path = GMSPath(fromEncodedPath: point)
                            let polyline = GMSPolyline(path: path)
                            polyline.strokeWidth = 4
                            polyline.strokeColor = Color.mainColor()
                            DispatchQueue.main.async {
                                polyline.map = strongSelf.mapView
                                
                                let camera = GMSCameraPosition.camera(withLatitude: userLocation.latitude, longitude: userLocation.longitude, zoom: 15)
                                strongSelf.mapView?.animate(to: camera)
                            }
                        }
                    }
                }
            } else {
                print(error!)
            }
        }
        
    }

}

// MARK: - Searchbar Delegate
extension MapViewController:UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        autocompleteController = GMSAutocompleteViewController()
        autocompleteController?.delegate = self
        DispatchQueue.main.async {
            self.present(self.autocompleteController!, animated: true, completion: nil)
        }
    }
}
// MARK: - AutocompleteController Delegate

extension MapViewController: GMSAutocompleteViewControllerDelegate {
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        eateriesLocation = CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        if let address = place.formattedAddress {
            searchBar.text = address
        }
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude))
        
        // Change map location
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 16)
        
        DispatchQueue.main.async {
            self.mapView?.clear()
            self.dismiss(animated: true, completion: nil)
            self.mapView?.camera = camera
            marker.map = self.mapView
        }
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

