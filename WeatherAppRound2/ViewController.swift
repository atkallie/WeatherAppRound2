//
//  ViewController.swift
//  WeatherAppRound2
//
//  Created by Ahmed T Khalil on 1/1/17.
//  Copyright © 2017 kalikans. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var city: UITextField!
    @IBOutlet var weatherResult: UILabel!
    
    @IBAction func weatherLoader(_ sender: Any) {
        let cityWebPage = city.text!.replacingOccurrences(of: " ", with: "-")
        
        let webpage: String = "http://www.weather-forecast.com/locations/" + cityWebPage + "/forecasts/latest"
        
        if let webURL = URL(string: webpage){
        
            let request = URLRequest(url: webURL)
            
            let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                var message: String = ""
                
                if error != nil{
                    
                    print(error as Any)
                    
                }else{
                    
                    if let unwrapped = data{
                    
                        let dataString = NSString(data: unwrapped, encoding: String.Encoding.utf8.rawValue)
                        
                        //split the dataString based off of the surrounding text to isolate what we desire
                        //remember to use the escape character '\' before any internal quotes
                        var strSeparator: String = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                        
                        if let contentArray = dataString?.components(separatedBy: strSeparator){
                            if contentArray.count>1{
                                strSeparator = "</span>"
                                let contentArray2 = contentArray[1].components(separatedBy: strSeparator)
                                if contentArray2.count>1{
                                    //degree symbol is 'option'+'shift'+'8' on a Mac
                                    message = contentArray2[0].replacingOccurrences(of: "&deg;", with: "°")
                                }
                            }
                        }
                
                    }
                }
                if message == "" {
                    message = "The weather there could not be found :("
                }
                
                //dispatches queue and displays text as soon as it is ready
                DispatchQueue.main.sync {
                    //need to use 'self' to refer to View Controller since we are currently within a closure
                    self.weatherResult.text = message
                }
            }
            task.resume()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

