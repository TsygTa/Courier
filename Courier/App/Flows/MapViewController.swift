//
//  MapViewController.swift
//  Courier
//
//  Created by Tatiana Tsygankova on 30/07/2019.
//  Copyright © 2019 Tatiana Tsygankova. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

/// Контроллер карты
public class MapViewController: UIViewController {
    
    @IBOutlet private weak var mapView: GMSMapView!
    
    /// Кнопка включения (выключения) отслеживания текущего  местоположения
    @IBOutlet private weak var myLocationButton: UIButton!
    
    /// Обрабатывает нажатие на кнопку включения (выключения)
    /// отслеживания текущего  местоположения
    @IBAction func myLocationButtonTap(_ sender: Any) {
        locationManager?.requestLocation()
        if Session.instance.isMyLocationUpdating {
            locationManager?.stopUpdatingLocation()
            myLocationButton.setImage(UIImage(named: "map_my_location_button_icon"), for: .normal)
            Session.instance.isMyLocationUpdating = false
        } else {
            locationManager?.startUpdatingLocation()
            myLocationButton.setImage(UIImage(named: "map_my_location_on_icon"), for: .normal)
            Session.instance.isMyLocationUpdating = true
        }
    }
    
    private var locationManager: CLLocationManager?
    
    /// Обрабатывает нажатие на кнопку увелиичения масштаба карты
    @IBAction private func onZoomInButtonTap(_ sender: Any) {
        guard (kGMSMaxZoomLevel - Session.instance.mapZoomLevel) >= 1  else { return }
        Session.instance.mapZoomLevel += 1
        mapView.animate(toZoom: Session.instance.mapZoomLevel)
    }
    
    /// Обрабатывает нажатие на кнопку уменьшения масштаба карты
    @IBAction private func onZoomOutButtonTap(_ sender: Any) {
        guard (Session.instance.mapZoomLevel - kGMSMinZoomLevel) >= 1 else { return }
        Session.instance.mapZoomLevel -= 1
        mapView.animate(toZoom: Session.instance.mapZoomLevel)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.configureMap()
        self.configureLocationManager()
    }
    
    /// Конфигурирует карту
    private func configureMap() {
        let coordinate = CLLocationCoordinate2D(latitude: 59.939095, longitude: 30.315868)
        
        let camera = GMSCameraPosition(target: coordinate, zoom: 17)
        self.mapView.camera = camera
    }
    
    /// Конфигурирует менеджер отслежииваниия местоположения
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
    }
}

// MARK: - Содержит реализацию методов CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else {
            return
        }
        addMarker(coordinate: coordinate)
    }
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.showAlert(error: error)
    }
    
    private func addMarker(coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        marker.map = self.mapView
        mapView.animate(toLocation: coordinate)
    }
}

