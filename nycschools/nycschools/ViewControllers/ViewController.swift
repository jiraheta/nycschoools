//
//  ViewController.swift
//  nycschools
//
//  Created by Jportdev on 6/12/21.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    // MARK: - Variables
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    var SchoolList = [SchoolModel]()
    var contentloaded = false
    
    // MARK: - UIVC lifecycle
    override func viewWillAppear(_ animated: Bool) {
        if contentloaded {
            self.tableview.reloadData()
        } else {
            loadSchools()
            contentloaded = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "NYC Open Data - Schools"
        //tableview delegate and datasource
        let child = SpinnerViewController()
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        // wait three seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.tableview.reloadData()
            //then remove the spinner view controller
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    // MARK: - loadSchools Method
    func loadSchools() {
        // Create URL
        let url = URL(string: Api.schools.rawValue)
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        // Specify HTTP Method to use
        request.httpMethod = HTTPMethod.get.rawValue
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("School List VC Response HTTP Status code: \(response.statusCode)")
            }
            // Convert HTTP Response Data to a simple String
            if let data = data {
                //print("Response data string:\n \(dataString)")
                do{
                let decode = JSONDecoder()
                self.SchoolList = try decode.decode([SchoolModel].self, from: data)
                } catch {
                    print("error: \(error)")
                }
            }
        }
        task.resume()
    }
}

// MARK: - TableView Extension
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if !SchoolList.isEmpty{
                return SchoolList.count
            }else {
                return 0
            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        var tableCell = tableView.dequeueReusableCell(withIdentifier: identifier)
        if tableCell == nil {
            tableCell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        let school = SchoolList[indexPath.row]
        let title = school.school_name
        tableCell?.textLabel?.text = title
        return tableCell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(SchoolList[indexPath.row].dbn)
        let SchoolDetailsVC = (storyboard?.instantiateViewController(identifier: "SchoolDetailsViewController")) as! SchoolDetailsViewController
        SchoolDetailsVC.title = SchoolList[indexPath.row].school_name
        SchoolDetailsVC.dbn = SchoolList[indexPath.row].dbn
        self.navigationController?.pushViewController(SchoolDetailsVC, animated: true)
        //UserDestailsVC.UserID = userID
    }
}
// MARK: - Dev Comments
/* There is a more elegant way to code this but due to time constrains on my end I choose to do this
   on both views to re-use the code. You will see the similarities on both tableVC. I have used this
   approach in other code challenges and serve the purpose of demostrating the ask. */
/* More the most part, there requirements were not enough to actually justify making a Modal View.
   As it will only be and extra file with one single method in it. which would the be one to use
   to call the service.
   Also, did not have time to finish the NetworkManager to have the viewControllers make the call
   from and instance of the view
   eg: something along this lines.
 
     class ListOfUsersModel {
         static var sharedModel = ListOfUsersModel()
         func getListOfUsers(completion: @escaping([UsersListModel]?,NetworkResponse) -> Void) {
             Network.shared.getListOfUsersQuery { list ,response in
                 if response.success {
                     completion( list , NetworkResponse(_success: true, _errorMessage: nil))
                 } else {
                     completion( list, NetworkResponse(_success: false, _errorMessage: response.error?.message))
                 }
             }
         }
     }
 
    */

