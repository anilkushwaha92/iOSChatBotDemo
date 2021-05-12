//
//  ChatBotVC.swift
//  ChatBotLibrary
//
//  Created by Anil Kushwaha on 10/05/21.
//

import UIKit
import AMKeyboardFrameTracker
import ADCountryPicker
import FirebaseCore
import FirebaseFirestore

public class ChatBotVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var tableviewList: UITableView! {
        didSet {self.tableviewList.dataSource = self
            self.tableviewList.delegate = self
        }
    }
    var uiValue : String = ""
    @IBOutlet var searchTextfield: UITextField!
    @IBOutlet var textView: UIView!
    @IBOutlet var bottomHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var countryCodeBtn: UIButton!
    @IBOutlet weak var countryCodeWidthConstraint: NSLayoutConstraint!
    let db = Firestore.firestore()
    var countValue = false
    var nodeValue = "0"
    var phoneExtension = "+91"
    var templateDictValue : [String : Any]?
    var templateArr : [[String : Any]] = []
    let keyboardFrameTrackerView = AMKeyboardFrameTrackerView.init(height: 60)
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var ratingHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var ratingMessage: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var sendMsgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var feedbackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var feedbackLbl: UILabel!
    @IBOutlet weak var startBotFlowBtn: UIButton!
    @IBOutlet weak var startBotFlowHieghtConstraint: NSLayoutConstraint!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        FirebaseApp.configure()
        self.tableviewList.keyboardDismissMode = .interactive
        
        self.keyboardFrameTrackerView.delegate = self
        self.searchTextfield.inputAccessoryView = self.keyboardFrameTrackerView
        
        searchTextfield.delegate = self
        
        methodForSetup()
        
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.keyboardFrameTrackerView.setHeight(self.textView.frame.height)

    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func methodForSetup(){
        
        self.tableviewList?.register(UINib(nibName: "LeftListCell", bundle: nil), forCellReuseIdentifier: "LeftListCell")
        self.tableviewList?.register(UINib(nibName: "RightListCell", bundle: nil), forCellReuseIdentifier: "RightListCell")
        self.tableviewList.separatorStyle = .none
        self.tableviewList.rowHeight = UITableView.automaticDimension
        self.tableviewList.estimatedRowHeight = 300
        
        ratingHeightConstraint.constant = 0.0
        countryCodeWidthConstraint.constant = 0.0
        countryCodeBtn.isHidden = true
        
        feedbackViewHeightConstraint.constant = 0.0
        feedbackLbl.isHidden = true
        startBotFlowHieghtConstraint.constant = 0.0
        startBotFlowBtn.isHidden = true
        
        ratingView.isHidden = true
        sendBtn.isHidden = false
        
        tableviewList.separatorStyle = .none
        btn1.methodForSetCornerRadious()
        btn2.methodForSetCornerRadious()
        btn3.methodForSetCornerRadious()
        btn4.methodForSetCornerRadious()
        btn5.methodForSetCornerRadious()
        
        reloadData()
        
    }
    
    func reloadData(){
        
        db.collection("user_"+"\(methodForGetBotIduserIdAgentIdCompanyId().2)").document("\(methodForGetBotIduserIdAgentIdCompanyId().1)").collection("chatbot").document("\(methodForGetBotIduserIdAgentIdCompanyId().0)").getDocument { (querySnapshot, err) in
            if let err = err{
                self.templateArr = []
                print("Error getting documents: \(err)")
            }else{
                self.templateArr = []
                if let templateDict = querySnapshot?.data(){
                    print(templateDict)
                    if let tempDict = templateDict["template"] as? [String : Any]{
                        self.templateDictValue = tempDict
                        if let nodeDict = tempDict["0"] as? [String : Any]{
                            self.templateArr.append(nodeDict)
                        }
                    }
                }
                self.tableviewList.reloadData()
            }
        }
        
    }
    
    func methodForGetBotIduserIdAgentIdCompanyId()->(String, String, String){
        let Id="https://chatbot.appypie.com/widget/loadbuild.js?cid=ko8dcpep-AGENT1620032215202-BOTID1620032215202&name=mixBuild"
        let botId = Id.split(separator: "=")[1].split(separator: "-")[2].split(separator: "&")[0]
        let agentId = Id.split(separator: "=")[1].split(separator: "-")[1].split(separator: "&")[0]
        let companyID = Id.split(separator: "=")[1].split(separator: "-")[0]
        return("\(botId)", "\(agentId)", "\(companyID)")
    }
    
    @IBAction func countryCodeBtnClickMethod(_ sender: Any) {
        
        let picker = ADCountryPicker()
        picker.delegate = self
        picker.showCallingCodes = true
        let pickerNavigationController = UINavigationController(rootViewController: picker)
        self.present(pickerNavigationController, animated: true, completion: nil)

    }
    
    @IBAction func sendBtnClickMethod(_ sender: UIButton) {
        
            if self.uiValue == "Get Phone"{
                if self.validatePhone(value: "\(self.searchTextfield.text ?? "")"){
                    self.templateArr.append(["text" : self.phoneExtension+" \(self.searchTextfield.text ?? "")"])
                    self.countValue = false
                    DispatchQueue.main.async {
                        self.searchTextfield.text = ""
                        self.methodForLoadData()
                    }
                }else{
                    
                    templateArr.append(["text" : "\(searchTextfield.text ?? "")"])
                    countValue = true
                    DispatchQueue.main.async {
                        self.searchTextfield.text = ""
                        self.methodForLoadData()
                    }
                    
                    DispatchQueue.global(qos: .background).async {
                        sleep(2)
                        
                        if let nodeDict = self.templateDictValue?["\(self.nodeValue)"] as? [String : Any]{
                            print(nodeDict)
                            if let validationDict = nodeDict["Validation"] as? [String : Any]{
                                if let unsuccessfulValue = validationDict["unsuccessful"] as? Int{
                                    self.methodForIncreaseCount(nodeValue: "\(unsuccessfulValue)")
                                }
                            }
                        }
                    }
                    
                }
            }else if self.uiValue == "Get Email"{
                if self.isValidEmail(testStr: "\(self.searchTextfield.text ?? "")"){
                    self.templateArr.append(["text" : "\(self.searchTextfield.text ?? "")"])
                    self.countValue = false
                    DispatchQueue.main.async {
                        self.searchTextfield.text = ""
                        self.methodForLoadData()
                    }
                }else{
                    
                    templateArr.append(["text" : "\(searchTextfield.text ?? "")"])
                    countValue = true
                    DispatchQueue.main.async {
                        self.searchTextfield.text = ""
                        self.methodForLoadData()
                    }
                    
                    DispatchQueue.global(qos: .background).async {
                        sleep(1)
                        
                        if let nodeDict = self.templateDictValue?["\(self.nodeValue)"] as? [String : Any]{
                            if let validationDict = nodeDict["Validation"] as? [String : Any]{
                                if let unsuccessfulValue = validationDict["unsuccessful"] as? Int{
                                    self.methodForIncreaseCount(nodeValue: "\(unsuccessfulValue)")
                                }
                            }
                        }
                    }
                    
                }
            }else{
                templateArr.append(["text" : "\(searchTextfield.text ?? "")"])
                countValue = false
                DispatchQueue.main.async {
                    self.searchTextfield.text = ""
                    self.methodForLoadData()
                }
            }
    }
    
    @IBAction func startBotAgainMethod(_ sender: UIButton) {
        methodForSetup()
    }
    
    @IBAction func ratingBtnClickMethod(_ sender: UIButton) {
        
        print("Tabg value : \(sender.tag)")
        
        feedbackViewHeightConstraint.constant = 50.0
        feedbackLbl.isHidden = false
        if let nodeDict = self.templateDictValue?["\(nodeValue)"] as? [String : Any]{
            feedbackLbl.text = "\(methodForPassCalculateTheNodeAndPassTheteextMessage(templateDict: nodeDict))".replacingOccurrences(of: "{{bot_name}}", with: "Snappy")
        }
        
        startBotFlowHieghtConstraint.constant = 0.0
        startBotFlowBtn.isHidden = true
        sendMsgHeightConstraint.constant = 0.0
        ratingHeightConstraint.constant = 0.0
        ratingView.isHidden = true
        sendBtn.isHidden = true
        
        DispatchQueue.global(qos: .background).async {
            sleep(2)
            DispatchQueue.main.async {
                self.feedbackViewHeightConstraint.constant = 0.0
                self.feedbackLbl.isHidden = true
                self.startBotFlowHieghtConstraint.constant = 50.0
                self.startBotFlowBtn.isHidden = false
            }
            
        }
        
    }
    
    func methodForIncreaseCount(nodeValue : String){
        
        self.nodeValue = nodeValue
        if let nodeDict = self.templateDictValue?["\(nodeValue)"] as? [String : Any]{

            if let uiVal = nodeDict["UI"] as? String{
                uiValue = "\(uiVal)"
            }
            
            sendMsgHeightConstraint.constant = 50.0
            ratingView.isHidden = true
            ratingHeightConstraint.constant = 0.0
            sendBtn.isHidden = false
            feedbackViewHeightConstraint.constant = 0.0
            feedbackLbl.isHidden = true
            startBotFlowHieghtConstraint.constant = 0.0
            startBotFlowBtn.isHidden = true
            
            if uiValue == "Handoffs"{
                
                //Add api here to send data on server
                
                    if let nodeValue = nodeDict["next"] as? Int{
                        
                            self.methodForIncreaseCount(nodeValue: "\(nodeValue)")
                        
                    }

                
            }else if uiValue == "Feedback"{
                
                ratingMessage.text = "\(methodForPassCalculateTheNodeAndPassTheteextMessage(templateDict: nodeDict))".replacingOccurrences(of: "{{bot_name}}", with: "Snappy")
                sendMsgHeightConstraint.constant = 0.0
                ratingHeightConstraint.constant = 125.0
                ratingView.isHidden = false
                sendBtn.isHidden = true
                
                if let nodeValue = nodeDict["next"] as? Int{

                    self.nodeValue = "\(nodeValue)"

                }
                
                searchTextfield.resignFirstResponder()
                
            }else if uiValue == "End Message"{
                
                feedbackViewHeightConstraint.constant = 0.0
                feedbackLbl.isHidden = true
                startBotFlowHieghtConstraint.constant = 50.0
                startBotFlowBtn.isHidden = false
                sendMsgHeightConstraint.constant = 0.0
                ratingHeightConstraint.constant = 0.0
                ratingView.isHidden = true
                sendBtn.isHidden = true
                
            }else{
                
                self.templateArr.append(nodeDict)
                DispatchQueue.main.async {
                    self.methodForLoadData()
                }
                
            }

        }
            
    }
    
    func methodForLoadData(){

        if #available(iOS 11.0, *) {
            self.tableviewList.performBatchUpdates({
                self.tableviewList.insertRows(at: [IndexPath(row: self.templateArr.count-1,
                                                             section: 0)],
                                              with: .bottom)
            }, completion: nil)
        } else {
            // Fallback on earlier versions
        }

        scrollToBottom()

    }
    
    func scrollToBottom(){

            DispatchQueue.main.async {
                let indexPath = IndexPath(
                    row: self.tableviewList.numberOfRows(inSection:  self.tableviewList.numberOfSections-1) - 1,
                    section: self.tableviewList.numberOfSections - 1)
                if self.hasRowAtIndexPath(indexPath: indexPath) {
                    self.tableviewList.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
    }
    
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
            return indexPath.section < tableviewList.numberOfSections && indexPath.row < tableviewList.numberOfRows(inSection: indexPath.section)
    }
    
    func validatePhone(value: String) -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: value)
    }
    
    func isValidEmail(testStr:String) -> Bool {
                print("validate emilId: \(testStr)")
                let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
                let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
                let result = emailTest.evaluate(with: testStr)
                return result
    }

}

extension ChatBotVC: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templateArr.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let nodeVal = templateArr[indexPath.row]["next"], "\(nodeVal)" != ""{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeftListCell") as! LeftListCell
            cell.selectionStyle = .none
       
            cell.messageLbl.text = "\(methodForPassCalculateTheNodeAndPassTheteextMessage(templateDict: templateArr[indexPath.row]))".replacingOccurrences(of: "{{bot_name}}", with: "Snappy")
            
            if self.uiValue == "Get Phone"{
                countryCodeWidthConstraint.constant = 50.0
                countryCodeBtn.isHidden = false
            }else{
                countryCodeWidthConstraint.constant = 0.0
                countryCodeBtn.isHidden = true
            }
            
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RightListCell") as! RightListCell
            cell.selectionStyle = .none
            cell.messageLbl.text = "\(methodForPassCalculateTheNodeAndPassTheteextMessageForUserInput(templateDict: templateArr[indexPath.row]))".replacingOccurrences(of: "{{bot_name}}", with: "Snappy")
            return cell
            
        }
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.alpha = 0

        UIView.animate(
            withDuration: 0.2,
            delay: 0.05 * Double(indexPath.row),
            animations: {
                cell.alpha = 1
        })

        if indexPath.row == templateArr.count-1{
            if countValue == false{
                if let nodeVal = templateArr[indexPath.row]["next"], "\(nodeVal)" != "<null>"{
                   
                    methodForIncreaseCount(nodeValue: "\(nodeVal)")
                    
                }else if let nodeVal = templateArr[indexPath.row-1]["next"], "\(nodeVal)" == "<null>"{
                    if let ValidationDict = templateArr[indexPath.row-1]["Validation"] as? [String : Any]{
                        if let successfullValue = ValidationDict["successful"]{
                            methodForIncreaseCount(nodeValue: "\(successfullValue)")
                        }
                    }
                }
            }
        }
    }
    
    func methodForPassCalculateTheNodeAndPassTheteextMessage(templateDict : [String : Any])-> String{

            if let dataMssage = templateDict["data"] as? [String : Any]{
                if let textMsg = dataMssage["text"] as? String{
                    return "\(textMsg)"
                }
            }
        
        return ""
        
    }
    
    func methodForPassCalculateTheNodeAndPassTheteextMessageForUnsuccesfull(templateDict : [String : Any])-> String{

            if let dataMssage = templateDict["data"] as? [String : Any]{
                if let textMsg = dataMssage["unsuccessful"] as? String{
                    return "\(textMsg)"
                }
            }
        
        return ""
        
    }
    
    func methodForPassCalculateTheNodeAndPassTheteextMessageForUserInput(templateDict : [String : Any])-> String{

                if let textMsg = templateDict["text"] as? String{
                    return "\(textMsg)"
                }
        
        return ""
        
    }
}

extension ChatBotVC: AMKeyboardFrameTrackerDelegate {
    public func keyboardFrameDidChange(with frame: CGRect) {
        let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 0.0
        let bottomSapcing = self.view.frame.height - frame.origin.y - tabBarHeight - self.keyboardFrameTrackerView.frame.height
        self.bottomHeightConstraint.constant = bottomSapcing > 0 ? bottomSapcing : 0
        self.view.layoutIfNeeded()
    }
}

extension ChatBotVC: ADCountryPickerDelegate{
    public func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        print(dialCode)
        countryCodeBtn.setTitle("+\(dialCode)", for: .normal)
        phoneExtension = "+\(dialCode)"
    }

}
