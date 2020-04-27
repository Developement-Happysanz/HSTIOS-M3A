//
//  DetailReport.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 25/04/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

class DetailReport: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var monthId = String()
    var year_id = String()
    
    var taskTitle = [String]()
    var taskType = [String]()
    var taskAttendanceDate = [String]()
    var taskComments = [String]()
    var taskStatus = [String]()
    var task_ID = [String]()
    var attandence_ID = [String]()
    var mobilizer_comments = [String]()
    
    @IBOutlet weak var tableview: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Mobilizer Work Report"
        self.getAttendaceDetail(month_id: monthId, year_id: year_id)
    }
    
    func getAttendaceDetail (month_id:String,year_id:String)
    {
        let functionName = "apipia/get_month_day_report_details/"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["mobilizer_id": GlobalVariables.mobilizer_id!,"user_id": GlobalVariables.user_id!,"year_id": year_id,"month_id":month_id]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
            {
                response in
                switch response.result
                {
                case .success:
                    MBProgressHUD.hide(for: self.view, animated: true)
                    print(response)
                    let JSON = response.result.value as? [String: Any]
                    let msg = JSON?["msg"] as? String
                    let status = JSON?["status"] as? String
                    if (status == "success")
                    {
                        let result = JSON?["result"] as? [Any]
                        
                        self.taskTitle.removeAll()
                        self.taskType.removeAll()
                        self.taskAttendanceDate.removeAll()
                        self.taskComments.removeAll()
                        self.taskStatus.removeAll()
                        self.task_ID.removeAll()
                        self.mobilizer_comments.removeAll()

                        for i in 0..<(result?.count ?? 0)
                        {
                            let dict = result?[i] as? [AnyHashable : Any]
                            let task_comments = dict?["comments"] as? String
                            let task_attendance_date = dict?["attendance_date"] as? String
                            let task_status = dict?["status"] as? String
                            let task_title = dict?["title"] as? String
                            let task_work_type = dict?["work_type"] as? String
                            let taskID = dict?["mobilizer_id"] as? String
                            let attance_id = dict?["id"] as? String
                            let mobilizerComments = dict?["mobilizer_comments"] as? String

                            self.taskTitle.append(task_title!)
                            self.taskType.append(task_work_type!)
                            self.taskAttendanceDate.append(task_attendance_date!)
                            self.taskComments.append(task_comments!)
                            self.taskStatus.append(task_status!)
                            self.task_ID.append(taskID!)
                            self.attandence_ID.append(attance_id!)
                            self.mobilizer_comments.append(mobilizerComments!)

                        }
                        
                        self.tableview.reloadData()

                    }
                    else
                    {
                        let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                           // print("You've pressed default");
                        }
                        alertController.addAction(action1)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    break
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return taskTitle.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "cell") as! UserDetailTableViewCell
        cell.assignedToLabel.text = taskType[indexPath.row]
        cell.tasktitle.text = taskAttendanceDate[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 84
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
