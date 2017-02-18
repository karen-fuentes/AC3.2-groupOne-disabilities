//
//  SocialServicesTableViewController.swift
//  HandyAccess
//
//  Created by Ana Ma on 2/18/17.
//  Copyright © 2017 NYCHandyAccess. All rights reserved.
//

import UIKit
import SnapKit

class SocialServicesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    var socialServices1 = [SocialService1]()
    let endpoint = "https://data.cityofnewyork.us/resource/386y-9exk.json"
    //    var metaViews = [MetaView]()
    //    var socialServices = [SocialService]()
    //    let endpoint = "https://data.cityofnewyork.us/api/views/69bm-3bc2/rows.json?accessType=DOWNLOAD"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewHierarchy()
        configureConstraints()
        self.view.backgroundColor = UIColor.white
        
        APIRequestManager.shared.getSocialServices1(endPoint: self.endpoint) { (socialServices: [SocialService1]?) in
            guard let validSocialServices = socialServices else { return }
            DispatchQueue.main.async {
                self.socialServices1 = validSocialServices
                self.socialSourceTableView.reloadData()
                dump(self.socialServices1)
            }
        }
        
        self.socialSourceTableView.register(SocialServiceTableViewCell.self, forCellReuseIdentifier: SocialServiceTableViewCell.cellIdentifier)
        
        self.navigationItem.leftBarButtonItem = self.filterBarButton
        //        APIRequestManager.shared.getSocialServicesViews(endPoint: self.endpoint) { (metaViews: [MetaView]?) in
        //            guard let validMetaViews = metaViews else { return }
        //            DispatchQueue.main.async {
        //                self.metaViews = validMetaViews
        //            }
        //        }
        //        APIRequestManager.shared.getSocialServicesData(endPoint: self.endpoint, metaViews: self.metaViews) { (socialServices: [SocialService]?) in
        //            guard let validSocialServices = socialServices else { return }
        //            DispatchQueue.main.async {
        //                self.socialServices = validSocialServices
        //                self.tableView.reloadData()
        //            }
        //        }
        
    }
    
    private func setupViewHierarchy() {
        self.view.addSubview(self.filterPicker)
        self.view.addSubview(self.socialSourceTableView)
    }
    
    private func configureConstraints() {
        self.filterPicker.snp.makeConstraints{ (view) in
            view.top.leading.trailing.equalToSuperview()
        }
        
        self.socialSourceTableView.snp.makeConstraints { (view) in
            view.top.equalTo(self.filterPicker.snp.bottom)
            view.bottom.leading.trailing.equalToSuperview()
        }
    }

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.socialServices1.count)
        return self.socialServices1.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SocialServiceTableViewCell.cellIdentifier, for: indexPath) as! SocialServiceTableViewCell
        
        let socialService = socialServices1[indexPath.row]
        cell.organizationNameLabel.text = socialService.organizationname
        cell.organizationDescriptionLabel.text = socialService.description
        guard let description = socialService.description else { return  cell }
        
        cell.detailTextLabel?.text = description

        return cell
    }

    func filter() {
        var returnArray = [SocialService1]()
        for service in returnArray {
            if service.disabilities == "Y" {
                returnArray.append(service)
            }
        }
    }
    
    lazy var filterBarButton: UIBarButtonItem = {
       let barButton = UIBarButtonItem()
        barButton.title = "Filter"
//        barButton.image =
        return barButton
    }()
    
    lazy var filterPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    lazy var socialSourceTableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
