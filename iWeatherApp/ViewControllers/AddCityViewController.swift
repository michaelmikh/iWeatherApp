//
//  AddCityViewController.swift
//  iWeatherApp
//
//  Created by Michael on 18.02.2018.
//  Copyright © 2018 Michael. All rights reserved.
//

import UIKit
import CoreData

class AddCityViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    var managedContext: NSManagedObjectContext!
    
    // MARK: - Outlets
    @IBOutlet weak var cityInput: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    // MARK: - Application lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        cityInput.delegate = self
        updateSaveButtonState()
        cityInput.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func updateSaveButtonState() {
        // disable button if input is empty
        let text = cityInput.text ?? ""
        doneButton.isEnabled = !text.isEmpty
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        updateSaveButtonState()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let cityName = cityInput.text, !cityName.isEmpty else {
            return false
        }
        
        let city = City(context: managedContext)
        city.name = cityName
        city.date = Date()
        
        do {
            try managedContext.save()
            dismissAndResign()
        } catch {
            log.error("Error saving data: \(error)")
            return false
        }
        
        return true
    }
    
    fileprivate func dismissAndResign() {
        dismiss(animated: true)
        cityInput.resignFirstResponder()
    }
    
    // MARK: - Actions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismissAndResign()
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        guard let cityName = cityInput.text, !cityName.isEmpty else {
            return
        }
        
        let city = City(context: managedContext)
        city.name = cityName
        city.date = Date()
        
        do {
            try managedContext.save()
            dismissAndResign()
        } catch {
            log.error("Error saving data: \(error)")
        }
    }
}
