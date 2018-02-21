//
//  CityDetailViewController.swift
//  iWeatherApp
//
//  Created by Michael on 20.02.2018.
//  Copyright © 2018 Michael. All rights reserved.
//

import UIKit

class CityDetailViewController: UIViewController {
    
    // MARK: - Properties
    var city: City!
    
    // MARK: - Outlets

    @IBOutlet weak var forecastText: UITextView!
    
    // MARK: - Application lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard var forecasts = city.forecasts!.allObjects as? [Forecast] else {
            return
        }
        
        // consider date is never nil
        forecasts = forecasts.sorted {
            $0.date! < $1.date!
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        for forecast in forecasts {
            let dateString = dateFormatter.string(from: forecast.date!)
            forecastText.text.append(dateString + "\n")
            
            let forecastDescription = """
            \(forecast.text ?? "<No data>")
            From \(forecast.minTemp) to \(forecast.maxTemp) ℃
            """
            
            forecastText.text.append(forecastDescription + "\n\n")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
