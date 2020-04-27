//
//  ChartViewController.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 18/02/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Charts
import Alamofire
import MBProgressHUD

class ChartViewController: UIViewController, IAxisValueFormatter {
 
    var month = [String]()
    var stu_count = [Double]()

    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Graph"
        NavigationBarTitleColor.navbar_TitleColor
        self.webRequest()
       
    }
    
    func webRequest ()
    {
        let functionName = "apimain/admin_graph_details"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["user_id": GlobalVariables.user_id!]
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
            {
                response in
                switch response.result
                {
                case .success:
                    print(response)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    let JSON = response.result.value as? [String: Any]
                    let msg = JSON?["msg"] as? String
                    let status = JSON?["status"] as? String
                    if (status == "success")
                    {
                        let graph_data = JSON?["graph_data"] as? [Any]
                        
                        self.stu_count.removeAll()
                        self.month.removeAll()
                        
                        for i in 0..<(graph_data?.count ?? 0)
                        {
                            let dict = graph_data?[i] as? [AnyHashable : Any]
                            let name = dict?["month"] as? String

                            if let stu_count = (dict!["stu_count"] as? NSString)?.doubleValue {
                                self.stu_count.append(stu_count as NSNumber as! Double)
                            }
                            
                            self.month.append(name!)
                        }
                        
                        self.setChart(dataPoints: self.month, values: self.stu_count)

                    }
                    else
                    {
                        let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
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
    
    func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
                
        for i in 0..<dataPoints.count
        {
            let dataEntry = BarChartDataEntry(x:Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }
                
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "No. of Students")
        chartDataSet.colors = ChartColorTemplates.colorful()
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData

        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:self.month)
        barChartView.xAxis.granularity = 1
        
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInBounce)
            
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    return month[Int(value)]
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
