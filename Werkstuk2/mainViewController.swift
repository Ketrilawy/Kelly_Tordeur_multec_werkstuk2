//
//  mainViewController.swift
//  Werkstuk2
//
//  Created by student on 12/05/18.
//  Copyright © 2018 student. All rights reserved.
//

import UIKit
import MapKit

class mainViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var pins: [Annotation] = []
    @IBOutlet var button: UIButton!
    @IBOutlet var label: UILabel!
    @IBOutlet var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getJSON(){
        let url = URL(string: "https://api.jcdecaux.com/vls/v1/stations?apiKey=5dc3b111b2420093bef59d27a694d1f8963ee959")
        let urlRequest = URLRequest(url: url!)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            var latitude:Double = 0.0
            var longitude:Double = 0.0
            
            guard error == nil else {
                print("error GET")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("geen data beschikbaar")
                return
            }
            guard let stations = try? JSONSerialization.jsonObject(with: responseData, options: []) as! [AnyObject] else {
                print("kan data niet lezen")
                return
            }
            for value in stations {
                let status = value["status"] as? String
                let name = value["name"] as? String
                for (positions,coordinates) in (value["position"] as? NSDictionary)!{
                    if positions as! String == "lat"{
                        latitude = coordinates as! Double
                    }
                    if positions as! String == "lng"{
                        longitude = coordinates as! Double
                    }
                }
                let pin = Annotation(title: name!, subtitle: status!, coordinate: CLLocationCoordinate2DMake(latitude,longitude))
                self.pins.append(pin)
            }
        }
        
        task.resume()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
