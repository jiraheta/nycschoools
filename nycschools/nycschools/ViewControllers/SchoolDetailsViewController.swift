//
//  SchoolDetailsViewController.swift
//  nycschools
//
//  Created by Jportdev on 6/13/21.
//

import Foundation
import UIKit

class SchoolDetailsViewController: UIViewController {
    // MARK: - Variables
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var tableview: UITableView!
    var dbn: String? //id of schools
    var SchoolContent = [String]()  //we will transfer the contentt of the model to an array of strings.
    
    // MARK: - UIVC lifecycle
    override func viewWillAppear(_ animated: Bool) {
        loadSchoolDetails()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        header.text = "School SAT Results"
        let child = SpinnerViewController()
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        // wait three seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.tableview.reloadData()
            //then remove the spinner view controller
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    // MARK: - loadSchoolsDetails Method
    func loadSchoolDetails() {
        // Create URL
        let url = URL(string: "\(Api.school_details.rawValue)?dbn=\(dbn ?? "")")
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = HTTPMethod.get.rawValue
        let task = URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("School Details VC Response HTTP Status code: \(response.statusCode)")
            }
            // Convert HTTP Response Data to a simple String
            if let data = data {
                do{
                    let decode = JSONDecoder()
                    //returns an array of SchoolDetailsModel
                    let schoolContentFromModel = try decode.decode([SchoolDetailsModel].self, from: data)
                    
                    //Since there is only 1 school. If there is no school, there is no data to process.
                    for school in schoolContentFromModel {
                        let num_testers = "Num of SAT test Taken: \(school.num_of_sat_test_takers)"
                        let reading = "SAT critial Avg reading score: \(school.sat_critical_reading_avg_score)"
                        let math = "SAT critial Avg math score: \(school.sat_math_avg_score)"
                        let writing = "SAT critial Avg writtig score: \(school.sat_writing_avg_score)"
                        SchoolContent.append(contentsOf: [num_testers, reading, math, writing])
                    }

                } catch {
                    print("error: \(error)")
                }
            }
        }
        task.resume()
    }
}
// MARK: - TableView Extension
extension SchoolDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /* if the array is empty it will show only one cell, which will contain a message
           that there is no data to display. Otherwise, it will populate the cells base on
           the count of the Array.
        */
        if !SchoolContent.isEmpty{
            return SchoolContent.count
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "schoolcell"
        var tableCell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if tableCell == nil {
            tableCell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        /* This check if data is present for us to present otherwise, we presend a message that there
           is no data  to present. */
        if SchoolContent.count == 0{
            tableCell?.textLabel?.text = "No data Available at this time..."
        }else{
            let content = SchoolContent[indexPath.row]
            tableCell?.textLabel?.text = content
        }
        return tableCell!
    }
    
    
}
// MARK: - Dev Comments
/* There is a more elegant way to code this but due to time constrains on my end I choose to do this
   on both views to re-use the code. You will see the similarities on both tableVC. I have used this
   approach in other code challenges and serve the purpose of demostrating the ask. */
