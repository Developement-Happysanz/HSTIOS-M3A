//
//  Prospects.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 08/02/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import SideMenu
import Alamofire

class Prospects: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    var student_name : NSMutableArray = NSMutableArray()
    var student_status : NSMutableArray = NSMutableArray()
    var studentID : NSMutableArray = NSMutableArray()
    var student_pic : NSMutableArray = NSMutableArray()
    var student_Pic = String()
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func menuButton(_ sender: Any)
    {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        let str = UserDefaults.standard.string(forKey: "fromDashboard")
//
//        if str != "YES"
//        {
//            setupSideMenu()
//        }

        
       // self.mainView.isHidden = false
       self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
       self.tableView.tableFooterView = UIView(frame: .zero)
       self.tableView.backgroundColor = UIColor.clear
        
        
        view.addSubview(segmentedControlContainerView)
        segmentedControlContainerView.addSubview(segmentedControl)
        segmentedControlContainerView.addSubview(bottomUnderlineView)
        
        // Constrain the container view to the view controller
        let safeLayoutGuide = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            segmentedControlContainerView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            segmentedControlContainerView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor),
            segmentedControlContainerView.widthAnchor.constraint(equalTo: safeLayoutGuide.widthAnchor),
            segmentedControlContainerView.heightAnchor.constraint(equalToConstant: Constants.segmentedControlHeight)
            ])
        
        // Constrain the segmented control to the container view
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: segmentedControlContainerView.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: segmentedControlContainerView.leadingAnchor),
            segmentedControl.centerXAnchor.constraint(equalTo: segmentedControlContainerView.centerXAnchor),
            segmentedControl.centerYAnchor.constraint(equalTo: segmentedControlContainerView.centerYAnchor)
            ])
        
        // Constrain the underline view relative to the segmented control
        NSLayoutConstraint.activate([
            bottomUnderlineView.bottomAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            bottomUnderlineView.heightAnchor.constraint(equalToConstant: Constants.underlineViewHeight),
            leadingDistanceConstraint,
            bottomUnderlineView.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments))
            ])
        
    }
    
    fileprivate func setupSideMenu()
    {
        // Define the menus
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
    }

    override func viewWillAppear(_ animated: Bool)
    {
        
        if GlobalVariables.user_type_name == "TNSRLM"
        {
            navigationLeftButton ()
            webRequestAll ()
        }
        else
        {
            navigationLeftButton ()
            navigationRightButton ()
            webRequestAll ()
        }
       
    }
    
    func navigationLeftButton ()
    {
        let str = UserDefaults.standard.string(forKey: "fromDashboard")

        if GlobalVariables.user_type_name == "TNSRLM" || str == "YES"
        {
            let navigationLeftButton = UIButton(type: .custom)
            navigationLeftButton.setImage(UIImage(named: "back-01"), for: .normal)
            navigationLeftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            navigationLeftButton.addTarget(self, action: #selector(menuButtonclick), for: .touchUpInside)
            let navigationButton = UIBarButtonItem(customView: navigationLeftButton)
            self.navigationItem.setLeftBarButton(navigationButton, animated: true)
        }
        else
        {
            let navigationLeftButton = UIButton(type: .custom)
            navigationLeftButton.setImage(UIImage(named: "sidemenu_button"), for: .normal)
            navigationLeftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            navigationLeftButton.addTarget(self, action: #selector(menuButtonclick), for: .touchUpInside)
            let navigationButton = UIBarButtonItem(customView: navigationLeftButton)
            self.navigationItem.setLeftBarButton(navigationButton, animated: true)
        }
    }
    @objc func menuButtonclick()
    {
        UserDefaults.standard.set("", forKey: "Prospect_View") //setObject

        if GlobalVariables.user_type_name == "TNSRLM"
        {
            self.performSegue(withIdentifier: "to_Dashboard", sender: self)
        }
        else
        {
            let str = UserDefaults.standard.string(forKey: "fromDashboard")
            
            if str == "YES"
            {
                self.performSegue(withIdentifier: "to_Dashboard", sender: self)
            }
            else
            {
                present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
            }
        }
    }
    
    func navigationRightButton ()
    {
        let navigationRightButton = UIButton(type: .custom)
        navigationRightButton.setImage(UIImage(named: "add"), for: .normal)
        navigationRightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        navigationRightButton.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        let navigationButton = UIBarButtonItem(customView: navigationRightButton)
        self.navigationItem.setRightBarButtonItems([navigationButton], animated: true)
    }
    
    private enum Constants {
        static let segmentedControlHeight: CGFloat = 50
        static let underlineViewColor: UIColor = .red
        static let underlineViewHeight: CGFloat = 2
    }

    // Container view of the segmented control
    private lazy var segmentedControlContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    // Customised segmented control
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        
        // Remove background and divider colors
        segmentedControl.backgroundColor =  UIColor.white
        segmentedControl.tintColor = .white
        
        // Append segments
        segmentedControl.insertSegment(withTitle: "All", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Confirmed", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "Rejected", at: 2, animated: true)
        
        // Select first segment by default
        segmentedControl.selectedSegmentIndex = 0
        
        // Change text color and the font of the NOT selected (normal) segment
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.gray,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)], for: .normal)
        
        // Change text color and the font of the selected segment
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)], for: .selected)
        
        // Set up event handler to get notified when the selected segment changes
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
        // Return false because we will set the constraints with Auto Layout
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    // The underline view below the segmented control
    private lazy var bottomUnderlineView: UIView = {
        let underlineView = UIView()
        underlineView.backgroundColor = Constants.underlineViewColor
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        return underlineView
    }()
    
    private lazy var leadingDistanceConstraint: NSLayoutConstraint = {
        return bottomUnderlineView.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor)
    }()
    
    private func changeSegmentedControlLinePosition() {
        let segmentIndex = CGFloat(segmentedControl.selectedSegmentIndex)
        let segmentWidth = segmentedControl.frame.width / CGFloat(segmentedControl.numberOfSegments)
        let leadingDistance = segmentWidth * segmentIndex
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.leadingDistanceConstraint.constant = leadingDistance
            self?.loadViewIfNeeded()
        })
    }
    
    @objc func clickButton()
    {
        self.performSegue(withIdentifier: "addProspects", sender: self)
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl)
    {
        changeSegmentedControlLinePosition()
        let segmentIndex = CGFloat(segmentedControl.selectedSegmentIndex)
        if segmentIndex == CGFloat(0.0)
        {
            webRequestAll ()
        }
        else if segmentIndex == CGFloat(1.0)
        {
            webRequestConfirmed()
        }
        else
        {
            webRequestRejected()
        }
    }
    
    func webRequestAll ()
    {
        let functionName = "apipia/list_students"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters
        if GlobalVariables.user_type_name == "TNSRLM"
        {
             parameters = ["user_id": GlobalVariables.pia_id!]
        }
        else
        {
             parameters = ["user_id": GlobalVariables.user_id!]
        }
        Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
            {
                response in
                switch response.result
                {
                case .success:
                    print(response)
                    let JSON = response.result.value as? [String: Any]
                    let msg = JSON?["msg"] as? String
                    let status = JSON?["status"] as? String
                    
                    self.student_name.removeAllObjects()
                    self.student_status.removeAllObjects()
                    self.student_pic.removeAllObjects()

                    if (status == "success")
                    {
                        self.mainView.isHidden = false
                        self.tableView.isHidden = false
                        let studentList = JSON?["studentList"] as? [Any]
                        
                        for i in 0..<(studentList?.count ?? 0)
                        {
                            let dict = studentList?[i] as? [AnyHashable : Any]
                            let studentName = dict?["name"] as? String
                            let Status = dict?["status"] as? String
                            let id = dict?["id"] as? String
                            let student_pic = dict?["student_pic"] as? String

                            self.student_name.add(studentName!)
                            self.student_status.add(Status!)
                            self.studentID.add(id!)
                            self.student_pic.add(student_pic!)

                        }
                        
                            self.tableView.reloadData()
                    }
                    else
                    {
                        self.tableView.isHidden = true
                        self.mainView.isHidden = true

                        let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                          //  self.mainView.isHidden = true
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
    
    func webRequestConfirmed ()
    {
        let functionName = "apipia/list_students_status"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters
        if GlobalVariables.user_type_name == "TNSRLM"
        {
            parameters = ["user_id": GlobalVariables.pia_id!, "status": "confirmed"]
        }
        else
        {
            parameters = ["user_id": GlobalVariables.user_id!, "status": "confirmed"]
        }
        Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
            {
                response in
                switch response.result
                {
                case .success:
                    print(response)
                    let JSON = response.result.value as? [String: Any]
                    let msg = JSON?["msg"] as? String
                    let status = JSON?["status"] as? String
                    
                    self.student_name.removeAllObjects()
                    self.student_status.removeAllObjects()
                    self.student_pic.removeAllObjects()

                    if (status == "success")
                    {
                        self.mainView.isHidden = false
                        self.tableView.isHidden = false
                        let studentList = JSON?["studentList"] as? [Any]
                       
                        for i in 0..<(studentList?.count ?? 0)
                        {
                            let dict = studentList?[i] as? [AnyHashable : Any]
                            let studentName = dict?["name"] as? String
                            let Status = dict?["status"] as? String
                            let id = dict?["id"] as? String
                            let student_pic = dict?["student_pic"] as? String


                            self.student_name.add(studentName!)
                            self.student_status.add(Status!)
                            self.studentID.add(id!)
                            self.student_pic.add(student_pic!)


                        }
                        
                            self.tableView.reloadData()
                    }
                    else
                    {
                        self.tableView.isHidden = true
                        self.mainView.isHidden = true

                        let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                         //   self.mainView.isHidden = true
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
    func webRequestRejected ()
    {
        let functionName = "apipia/list_students_status"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters
        if GlobalVariables.user_type_name == "TNSRLM"
        {
            parameters = ["user_id": GlobalVariables.pia_id!, "status": "rejected"]
        }
        else
        {
            parameters = ["user_id": GlobalVariables.user_id!, "status": "rejected"]
        }
        Alamofire.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: nil).responseJSON
            {
                response in
                switch response.result
                {
                case .success:
                    print(response)
                    let JSON = response.result.value as? [String: Any]
                    let msg = JSON?["msg"] as? String
                    let status = JSON?["status"] as? String
                    self.student_name.removeAllObjects()
                    self.student_status.removeAllObjects()
                    self.student_pic.removeAllObjects()

                    if (status == "success")
                    {
                        self.mainView.isHidden = false
                        self.tableView.isHidden = false
                        let studentList = JSON?["studentList"] as? [Any]
                        for i in 0..<(studentList?.count ?? 0)
                        {
                            let dict = studentList?[i] as? [AnyHashable : Any]
                            let studentName = dict?["name"] as? String
                            let Status = dict?["status"] as? String
                            let id = dict?["id"] as? String
                            let student_pic = dict?["student_pic"] as? String

                            self.student_name.add(studentName!)
                            self.student_status.add(Status!)
                            self.studentID.add(id!)
                            self.student_pic.add(student_pic!)


                        }
                            self.tableView.reloadData()
                    }
                    else
                    {
                        self.tableView.isHidden = true
                        self.mainView.isHidden = true

                        let alertController = UIAlertController(title: "M3", message: msg, preferredStyle: .alert)
                        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
                            print("You've pressed default");
                         //   self.mainView.isHidden = true
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
        return student_name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! ProspectsTableViewCell
        
        cell.nameLabel.text = (student_name[indexPath.row] as! String)
        cell.statusLabel.text = (student_status[indexPath.row] as! String)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if GlobalVariables.user_type_name != "TNSRLM"
        {
            GlobalVariables.studentid = (studentID[indexPath.row] as! String)
            UserDefaults.standard.set("fromstudentView", forKey: "View") //setObject
            self.student_Pic = student_pic[indexPath.row] as! String
            self.performSegue(withIdentifier: "studentDetail", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 44
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "studentDetail") {
            let vc = segue.destination as! CandidateForm
            vc.studentPic = self.student_Pic
        }
    }
    

}
