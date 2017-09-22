//
//  InfoViewController.swift
//  MCICafe
//
//  Created by Erick Barbosa on 1/10/17.
//  Copyright © 2017 Erick Barbosa. All rights reserved.
//

import UIKit
import MapKit
import Firebase
class InfoViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  let regionRadius: CLLocationDistance = 1000
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    mapView.delegate = self
    let location = CLLocation(latitude: 25.778511, longitude: -80.190155)
    
    centerMapOnLocation(location: location)
    
    let mciCafe = Artwork(title: "MCI Café",
                          locationName: "Miami Culinary Institute",
                          discipline: "Food",
                          coordinate: CLLocationCoordinate2D(latitude: 25.778511, longitude: -80.190155))
    
    self.mapView.addAnnotation(mciCafe)
    
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func goToMdcButton(_ sender: AnyObject) {
    let url = URL(string: "http://www.miamidadeculinary.com")
    goToURL(url: url!)
    
    
  }
  @IBAction func phoneButton(_ sender: UIButton) {
    let phoneNumber = "3052373276"
    let cleanNumber = phoneNumber.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
    guard let number = URL(string: "telprompt://" + cleanNumber) else { return }
    
    
    goToURL(url: number)
  }
  @IBAction func facebookWebButton(_ sender: UIButton) {
    let url = URL(string: "https://www.facebook.com/MiamiCulinaryInstitute")
    goToURL(url: url!)
  }
  
  @IBAction func twitterWebButton(_ sender: UIButton) {
    let url = URL(string: "https://twitter.com/MDC_Culinary")
    goToURL(url: url!)
  }
  
  @IBAction func youtubeWebButton(_ sender: UIButton) {
    let url = URL(string: "https://www.youtube.com/user/MiamiDadeCulinary")
    goToURL(url: url!)
    
  }
  @IBAction func instangramWebButton(_ sender: UIButton) {
    let url = URL(string: "https://instagram.com/mcimedia")
    goToURL(url: url!)
    
  }
  
  func centerMapOnLocation(location: CLLocation) {
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                              regionRadius * 2.0, regionRadius * 2.0)
    mapView.setRegion(coordinateRegion, animated: true)
  }
  func goToURL(url: URL) {
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
  }
  
  
  
  @IBAction func goToViewButton(_ sender: UIButton) {
    
    // if manager is already logged in go to notification else login page
    if ParseData.isLogIn() {
      
      let chatView = ViewController()
      let chatNavigationController = UINavigationController(rootViewController: chatView)
      present(chatNavigationController, animated: true, completion: nil)
      
    }else{
      let controller = storyboard?.instantiateViewController(withIdentifier: "logIn") as! ManagerLogInViewController
      self.present(controller, animated: true, completion: nil)
    }
    
    
  }
  
}
