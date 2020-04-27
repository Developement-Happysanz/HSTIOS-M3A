//
//  ViewDocument.swift
//  M3 Admin
//
//  Created by Happy Sanz Tech on 21/04/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class ViewDocument: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var doc_name = [String]()
    var doc_master_id =  [String]()
    var doc_type =  [String]()
    var file_name = [String]()
    let documentInteractionController = UIDocumentInteractionController()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationRightButton()
        self.webRequest()
        self.tableView.backgroundColor = UIColor.white
        documentInteractionController.delegate = self
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func navigationRightButton ()
    {
        let navigationRightButton = UIButton(type: .custom)
        navigationRightButton.setImage(UIImage(named: "documentEdit"), for: .normal)
        navigationRightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        navigationRightButton.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        let navigationButton = UIBarButtonItem(customView: navigationRightButton)
        self.navigationItem.setRightBarButtonItems([navigationButton], animated: true)
    }
    
    @objc func clickButton()
    {
        self.performSegue(withIdentifier: "to_documentPage", sender: self)
    }
    
    func webRequest ()
    {
        let functionName = "apipia/prospects_document/"
        let baseUrl = Baseurl.baseUrl + functionName
        let url = URL(string: baseUrl)!
        let parameters: Parameters = ["prospect_id":  GlobalVariables.studentid!]
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
                    if (status == "success")
                    {
                        let doc_data = JSON?["doc_data"] as? [Any]
//
                        self.doc_name.removeAll()
                        self.doc_master_id.removeAll()
                        self.doc_type.removeAll()
                        self.file_name.removeAll()

//
                        for i in 0..<(doc_data?.count ?? 0)
                        {
                            let dict = doc_data?[i] as? [AnyHashable : Any]
                            let docname = dict?["doc_name"] as? String
                            let docmaster_id = dict?["doc_master_id"] as? String
                            let doctype = dict?["doc_type"] as? String
                            let filename = dict?["file_name"] as? String


                            self.doc_name.append(docname ?? "")
                            self.doc_master_id.append(docmaster_id ?? "")
                            self.doc_type.append(doctype!)
                            self.file_name.append(filename ?? "")


                        }
                        
                           self.tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doc_name.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! DocumentTableViewCell
        cell.textField.text = doc_name[indexPath.row]
        cell.textField.isEnabled = false
        cell.textField.layer.cornerRadius = 5
        cell.textField.layer.borderWidth = 1
        cell.textField.layer.borderColor = UIColor.gray.cgColor
        
        cell.downloadButton.tag = indexPath.row;
        cell.downloadButton.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        cell.cellIndex = indexPath as NSIndexPath
        
         return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }
    
   @objc func connected(sender: UIButton)
   {
        let alertController = UIAlertController(title: "M3", message: "Are you sure want to Download ??", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
           // print("You've pressed default");
            MBProgressHUD.showAdded(to: self.view, animated: true)
            let buttonPostion = sender.convert(sender.bounds.origin, to: self.tableView)
            if let indexPath = self.tableView.indexPathForRow(at: buttonPostion) {
                  let rowIndex =  indexPath.row
            let _url = self.file_name[rowIndex]
            self.storeAndShare(withURLString: _url)
            MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
        alertController.addAction(action1)
        self.present(alertController, animated: true, completion: nil)
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

extension ViewDocument {
    
    func share(url: URL) {
        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        documentInteractionController.presentPreview(animated: true)
    }
    
    /// This function will store your document to some temporary URL and then provide sharing, copying, printing, saving options to the user
    func storeAndShare(withURLString: String)
    {
        guard let url = URL(string: withURLString) else { return }
        /// START YOUR ACTIVITY INDICATOR HERE
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            let tmpURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(response?.suggestedFilename ?? "fileName.png")
            do {
                try data.write(to: tmpURL)
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                /// STOP YOUR ACTIVITY INDICATOR HERE
                MBProgressHUD.hide(for: self.view, animated: true)
                self.share(url: tmpURL)
            }
            }.resume()
    }
}

extension ViewDocument: UIDocumentInteractionControllerDelegate
{
    /// If presenting atop a navigation stack, provide the navigation controller in order to animate in a manner consistent with the rest of the platform
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
        return navVC
    }
}

extension URL
{
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}
