//
//  ViewController.swift
//  SushiTime 2.0
//
//  Created by Student on 2016-05-20.
//  Copyright © 2016 Scott Blackwell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //outlets
    @IBOutlet weak var cityNameTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var cityTempLabel: UILabel!
    
    //if button pressed: get localized weather (based on user input)
    @IBAction func getDataButton(sender: AnyObject) {
        getWeatherData("http://api.openweathermap.org/data/2.5/weather?q=\(cityNameTextField.text)")
    }

    //call for API data
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeatherData("http://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=9aa3efef6de3b5bd8331807ab02d36cf")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //get weather data in String
    func getWeatherData(urlString: String) {
        let url = NSURL(string: urlString) //creating URL object
        
        //http request
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
            dispatch_async(dispatch_get_main_queue(), {
                self.setLabels(data!)
            })
        }
        
        task.resume() //debug - start task from its suspension state
    }

    //setting labels
    func setLabels(weatherData: NSData){
        var jsonError: NSError?
        
        //should return as structure (to be parsed as NSDictionary...)
        let json = NSJSONSerialization.JSONObjectWithData(weatherData, options: [], error: &jsonError) as NSDictionary
        
        //CITY
        //if we get a value, the name perameter will be set
        if let name = json["name"] as? String { //parsing (extraction city name)
            cityNameLabel.text = name
        }
        
        //TEMP
        //
        if let main = json["main"] as NSDictionary {
            if let temp = main["temp"] as? Double { //parsing (extracting temp)
                //add 273.15
                cityTempLabel.text = String(format: "%.1f", temp)
                
            }
        }
    }
}


