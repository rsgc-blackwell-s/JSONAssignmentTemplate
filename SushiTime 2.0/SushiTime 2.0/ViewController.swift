//
//  ViewController.swift
//  SushiTime 2.0
//
//  Created by Student on 2016-05-20.
//  Copyright © 2016 Scott Blackwell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityTempLabel: UILabel!
    
    @IBAction func getDataButton(sender: AnyObject) {
        getWeatherData("http://api.openweathermap.org/data/2.5/weather?q=\(cityNameTextField.text)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getWeatherData("http://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=9aa3efef6de3b5bd8331807ab02d36cf")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getWeatherData(urlString: String) {
        let url = NSURL(string: urlString)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
            dispatch_async(dispatch_get_main_queue(), {
                self.setLabels(data!)
            })
        }
        task.resume()
    }

    func setLabels(weatherData: NSData){
        var jsonError: NSError?
        
        let json = NSJSONSerialization.JSONObjectWithData(weatherData, options: [], error: &jsonError) as NSDictionary
    
        if let name = json["name"] as? String {
            cityNameLabel.text = name
        }
        
        if let main = json["main"] as NSDictionary {
            if let temp = main["temp"] as? Double {
                //add 273.15
                cityTempLabel.text = String(format: "%.1f", temp)
                
            }
        }
    }
}


