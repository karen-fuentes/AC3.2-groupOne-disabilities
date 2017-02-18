//
//  EventsViewController.swift
//  HandyAccess
//
//  Created by Karen Fuentes on 2/17/17.
//  Copyright © 2017 NYCHandyAccess. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDelegate {
    
    var events = [NYCEventCalendarModel]()
    var datePicker: UIDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIRequestManager.shared.getData(endPoint: "https://api.cityofnewyork.us/calendar/v1/search.htm?app_id=e40a1f49&app_key=077f86713488d92de18df675a800dcd8") { (data: Data?) in
            guard let validData = data else { return }
            DispatchQueue.main.async {
                self.events = NYCEventCalendarModel.getEvents(from: validData)!
                self.eventTableView.reloadData()
            }
        }
        
        view.backgroundColor = .gray
        
        //Date Picker
        datePicker.timeZone = TimeZone.current
        datePicker.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: 250.0)
        datePicker.backgroundColor = .white
        self.view.addSubview(datePicker)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        
        //TableView
        self.eventTableView.register(EventTableViewCell.self, forCellReuseIdentifier: EventTableViewCell.cellIdentifier)
        self.eventTableView.estimatedRowHeight = 150
        self.eventTableView.rowHeight = UITableViewAutomaticDimension
        self.eventTableView.delegate = self
        
    }
    
    func datePickerValueChanged(_ sender: UIDatePicker){
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        print("Selected value \(selectedDate)")
    }
    
    
    func setUpViewHierarchy() {
        
        
    }
    
    func configureConstraints() {
        
        
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.cellIdentifier, for: indexPath) as! EventTableViewCell
        
        let event = events[indexPath.row]
        cell.eventNameLabel.text = event.name
        cell.eventDescriptionLabel.text = event.description
        return cell
    }
    
    lazy var eventTableView : UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
