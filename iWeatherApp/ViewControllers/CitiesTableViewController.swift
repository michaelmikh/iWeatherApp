//
//  CitiesTableViewController.swift
//  iWeatherApp
//
//  Created by Michael on 15.02.2018.
//  Copyright © 2018 Michael. All rights reserved.
//

import UIKit
import CoreData

class CitiesTableViewController: UITableViewController {
    
    // MARK: - Properies
    
    var resultsController: NSFetchedResultsController<City>!
    let coreDataStack = CoreDataStack()
    
    let weatherAPI = WeatherAPIClient()
    
    private var refresher: UIRefreshControl!
    
    // MARK: - Application lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Updating weather data...")
        refresher.tintColor = UIColor(red: 0.8, green: 0.2, blue: 0.8, alpha: 1.0)
        refresher.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableView.refreshControl = refresher
        
        // Creating request
        let sortDescriptors = NSSortDescriptor(key: "date", ascending: true)
        
        let request: NSFetchRequest<City> = City.fetchRequest()
        request.sortDescriptors = [sortDescriptors]
        
        resultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: nil, cacheName: nil)
        
        resultsController.delegate = self
        
        // Perform fetching
        do {
            try resultsController.performFetch()
            
            tableView.reloadData()
            
        } catch {
            log.error("Error performing fetch: \(error)")
        }
    }
    
    @objc private func refreshTable() {
        refreshData(andEndRefreshing: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshData(andEndRefreshing: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableViewDelegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController.sections?[section].numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell", for: indexPath)
        
        // Configure the cell...
        let city = resultsController.object(at: indexPath)
        
        cell.textLabel?.text = city.name
        cell.detailTextLabel?.text = String(city.currentTemp) + "℃"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completion) in
            let city = self.resultsController.object(at: indexPath)
            self.resultsController.managedObjectContext.delete(city)
            do {
                try self.resultsController.managedObjectContext.save()
                completion(true)
            } catch {
                log.error("Delete failed: \(error)")
                completion(false)
            }
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = sender as? UIBarButtonItem, let vc = segue.destination as? AddCityViewController {
            vc.managedContext = resultsController.managedObjectContext
        }
        
        if let cell = sender as? UITableViewCell, let vc = segue.destination as? CityDetailViewController {
            guard let indexPath = tableView.indexPath(for: cell) else {
                log.error("not found index path for cell")
                return
            }
            
            let city = self.resultsController.object(at: indexPath)
            vc.city = city
        }
    }
}

extension CitiesTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
    }
}

extension CitiesTableViewController {
    func refreshData(andEndRefreshing: Bool) {
        DispatchQueue.global(qos: .background).async {
            for city in self.resultsController.fetchedObjects! {
                let weatherEndpoint = WeatherEndpoint.threeDaysForecast(city: city.name!)
                
                self.weatherAPI.weather(with: weatherEndpoint) { (either) in
                    switch either {
                    case .value(let weather):
                        weather.weatherToCity(withCity: city)
                    case .error(let error):
                        log.error(error.localizedDescription)
                    }
                }
            }
            
            // Trying to save changes we just recieved
            do {
                try self.resultsController.managedObjectContext.save()
            } catch {
                log.error("Error saving object: \(error)")
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                if andEndRefreshing {
                    self.refresher.endRefreshing()
                }
            }
        }
    }
}
