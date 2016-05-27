//
//  ViewController.swift
//  SushiTime 2.0
//
//  Created by Student on 2016-05-20.
//  Copyright © 2016 Scott Blackwell. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //label outlets
    @IBOutlet weak var cityTempLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    //loading icon outlet
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    
    //sushi image outlet
    @IBOutlet weak var sushiPicture: UIImageView!
    
    //call for API data
    override func viewDidLoad() {
        super.viewDidLoad()
        //getWeatherData("http://api.openweathermap.org/data/2.5/weather?q=London,uk&appid=9aa3efef6de3b5bd8331807ab02d36cf")
        
        //start loading icon; hide when finished
        loadingIcon.startAnimating()
        loadingIcon.hidesWhenStopped = true;
    
    getMyJSON()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Views that need to be accessible to all methods
    let jsonResult = UILabel()
    
    // If data is successfully retrieved from the server, we can parse it here
    func parseMyJSON(theData : NSData) {
        
        // Print the provided data
        print("")
        print("====== the data provided to parseMyJSON is as follows ======")
        print(theData)
        
        // De-serializing JSON can throw errors, so should be inside a do-catch structure
        do {
            
            // Do the initial de-serialization
            // Source JSON is here:
            // http://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=9aa3efef6de3b5bd8331807ab02d36cf
            let json = try NSJSONSerialization.JSONObjectWithData(theData, options: NSJSONReadingOptions.AllowFragments)
            
            // Print retrieved JSON
            print("")
            print("====== the retrieved JSON is as follows ======")
            print(json)
            
            // Now we can parse this...
            print("")
            print("Now, add your parsing code here...")
            
            if let weatherData = json as? [String : AnyObject] {
                
                // if this worked, I have a dictionary
                print("=======")
                print("The value for the 'main' key is: ")
                print(weatherData["main"])
                print("=======")
                
                if let weatherMain = weatherData["main"] as? [String : AnyObject] {
                    
                    // if this worked, we can use this data
                    print("======= Temperature =======")
                    print(weatherMain["temp"])
                    
                    //declaring TempOpt
                    let TempOpt = (weatherMain["temp"])
                    
                    //converting temp to an optional
                    if let temp = TempOpt {
                        print (temp)
                        
                        //converting optional value to an int
                        let tempInt: Int = temp as! Int
                        print (tempInt - 273)
                        
                        //display temperature to user
                        cityTempLabel.text = ("\(tempInt - 273)˙C")
                        
                        //stop loading icon when data is retrieved
                        loadingIcon.stopAnimating()
                        
                        //deciding if it's sushi time or not!
                        if (tempInt - 273 >= 20){
                            answerLabel.text = ("Very hot! Go get some sushi my friend!")
                        } else {
                            answerLabel.text = ("So cold! No sushi for you silly!")
                        }
                        
                    }
                }
            }
            
            // Now we can update the UI
            // (must be done asynchronously)
            dispatch_async(dispatch_get_main_queue()) {
                self.jsonResult.text = "parsed JSON should go here"
            }
            
        } catch let error as NSError {
            print ("Failed to load: \(error.localizedDescription)")
        }
        
        
    }
    
    // Set up and begin an asynchronous request for JSON data
    func getMyJSON() {
        
        // Define a completion handler
        // The completion handler is what gets called when this **asynchronous** network request is completed.
        // This is where we'd process the JSON retrieved
        let myCompletionHandler : (NSData?, NSURLResponse?, NSError?) -> Void = {
            
            (data, response, error) in
            
            // This is the code run when the network request completes
            // When the request completes:
            //
            // data - contains the data from the request
            // response - contains the HTTP response code(s)
            // error - contains any error messages, if applicable
            
            // Cast the NSURLResponse object into an NSHTTPURLResponse object
            if let r = response as? NSHTTPURLResponse {
                
                // If the request was successful, parse the given data
                if r.statusCode == 200 {
                    
                    // Show debug information (if a request was completed successfully)
                    print("")
                    print("====== data from the request follows ======")
                    print(data)
                    print("")
                    print("====== response codes from the request follows ======")
                    print(response)
                    print("")
                    print("====== errors from the request follows ======")
                    print(error)
                    
                    if let d = data {
                        
                        // Parse the retrieved data
                        self.parseMyJSON(d)
                        
                    }
                    
                }
                
            }
            
        }
        
        // Define a URL to retrieve a JSON file from
        let address : String = "http://api.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=9aa3efef6de3b5bd8331807ab02d36cf"
        
        // Try to make a URL request object
        if let url = NSURL(string: address) {
            
            // We have an valid URL to work with
            print(url)
            
            // Now we create a URL request object
            let urlRequest = NSURLRequest(URL: url)
            
            // Now we need to create an NSURLSession object to send the request to the server
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config)
            
            // Now we create the data task and specify the completion handler
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: myCompletionHandler)
            
            // Finally, we tell the task to start (despite the fact that the method is named "resume")
            task.resume()
            
        } else {
            
            // The NSURL object could not be created
            print("Error: Cannot create the NSURL object.")
            
        }
        
}



}