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
import RealmSwift

/// Контроллер карты
public class MapViewController: UIViewController {
    
    private var route: GMSPolyline?
    private var routePath: GMSMutablePath?
    private var selfieImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    private var marker: GMSMarker?
    
    @IBOutlet private weak var mapView: GMSMapView!
    
    private let locationManager = LocationManager.instance
    
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
    
    /// Обрабатывает нажатие на кнопку Начать трек
    @IBAction private func onStartTrackTap(_ sender: Any) {
        self.route?.map = nil
        self.route = GMSPolyline()
        self.route?.strokeWidth = 4
        self.route?.strokeColor = UIColor.blue
        self.routePath = GMSMutablePath()
        self.route?.map = self.mapView
        Session.instance.isMyLocationUpdating = true
        locationManager.startUpdatingLocation()
    }
    
    /// Обрабатывает нажатиие на кнопку Закончить трек
    @IBAction private func onEndTrackTap(_ sender: Any) {
        guard let path = self.routePath else { return }
        DatabaseService.deleteData(type: Path.self)
        DatabaseService.saveData(data: Path(path:path))
        Session.instance.isMyLocationUpdating = false
        locationManager.stopUpdatingLocation()
        self.removeMarker()
    }
    
    /// Обрабатывает нажатие на кнопку Отобразить предыдущий трек
    @IBAction func onPreviousTrackTap(_ sender: Any) {
        if Session.instance.isMyLocationUpdating {
            self.showAlert(title: "Attention", message: "The current track will be finished", withCancel: true) { action in
                Session.instance.isMyLocationUpdating = false
                self.locationManager.stopUpdatingLocation()
                self.drawPreviousPath()
            }
        } else {
            self.drawPreviousPath()
        }
    }
    
    private func drawPreviousPath() {
        
        guard let pathResults = DatabaseService.getData(type: Path.self),
            let encodedPath = pathResults.first?.encodedPath,
            let path = GMSMutablePath(fromEncodedPath: encodedPath) else { return }
        
        self.route?.map = nil
        self.removeMarker()

        self.routePath = path
        self.route = GMSPolyline(path: path)
        self.route?.strokeWidth = 4
        self.route?.strokeColor = UIColor.brown
        self.route?.map = self.mapView
        
        var bounds = GMSCoordinateBounds()
        for index in 1...path.count() {
            bounds = bounds.includingCoordinate(path.coordinate(at: index))
        }
        mapView.animate(with: GMSCameraUpdate.fit(bounds))
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.configureMap()
        self.configureLocationManager()
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(back(sender:)))
        self.navigationItem.leftBarButtonItem = backButton
        
        self.selfieImageView.layer.cornerRadius = self.selfieImageView.frame.size.width/2
        self.selfieImageView.layer.masksToBounds = true
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.selfieImageView.image = PhotoService.getPhoto()
    }

    @objc func back(sender: UIBarButtonItem) {
        if Session.instance.isMyLocationUpdating {
            self.showAlert(title: "Attention", message: "The current track will be finished", withCancel: true) { action in
                Session.instance.isMyLocationUpdating = false
                self.locationManager.stopUpdatingLocation()
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /// Конфигурирует карту
    private func configureMap() {
        let coordinate = CLLocationCoordinate2D(latitude: 59.939095, longitude: 30.315868)
        
        let camera = GMSCameraPosition(target: coordinate, zoom: 17)
        self.mapView.camera = camera
    }
    
    /// Конфигурирует менеджер отслежииваниия местоположения
    private func configureLocationManager() {
        locationManager
            .location
            .asObservable()
            .bind { [weak self] location in
                guard Session.instance.isMyLocationUpdating,
                    let location = location else { return }
                self?.removeMarker()
                self?.addMarker(coordinate: location.coordinate)
                self?.routePath?.add(location.coordinate)
                self?.route?.path = self?.routePath
                let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: Session.instance.mapZoomLevel)
                self?.mapView.animate(to: position)
        }
    }
    
    private func addMarker(coordinate: CLLocationCoordinate2D) {
        let marker = GMSMarker(position: coordinate)
        marker.iconView = self.selfieImageView
        marker.map = self.mapView
        self.marker = marker
    }
    
    private func removeMarker() {
        marker?.map = nil
        marker = nil
    }
}

