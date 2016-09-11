//
//  MainViewController.swift
//  Politicall
//
//  Created by Sahil Ambardekar on 9/10/16.
//  Copyright © 2016 Pennhacks. All rights reserved.
//

import UIKit
import MaterialControls

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userData: UserData! // set before segue
    @IBOutlet weak var phoneView: UIImageView!
    @IBOutlet weak var callsLabel: UILabel!
    @IBOutlet weak var successesLabel: UILabel!
    @IBOutlet weak var rejectsLabel: UILabel!
    @IBOutlet weak var averageDurationLabel: UILabel!
    @IBOutlet weak var formView: UIView!
    @IBOutlet weak var cancelView: UIImageView!
    var nameTextField: MDTextField!
    var leaderboard: [LeaderboardPerson] = []
    var switches = [MDSwitch]()
    @IBOutlet weak var leaderboardTableView: UITableView!
    var formActive: Bool = false {
        didSet {
            formView.hidden = !formActive
        }
    }
    var lastPhoneNumber: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateLabels()
        PoliticallService.sharedService.getLeaderboard { (success, leaderboard) in
            if success {
                self.leaderboard = leaderboard
                self.leaderboardTableView.reloadData()
            } else {
                print("Failed to get leaderboard")
            }
        }
    }
    
    func updateLabels() {
        callsLabel.text = "\(userData.totalCalls)"
        successesLabel.text = "\(userData.pickedCalls)"
        rejectsLabel.text = "\(userData.droppedCalls)"
        averageDurationLabel.text = secondsToString(userData.averageCallDuration)
    }
    
    override func viewDidAppear(animated: Bool) {
        setupFormView()
    }
    
    func setupFormView() {
        formView.layer.cornerRadius = 5
        formView.layer.shadowColor = UIColor.blackColor().CGColor
        formView.layer.shadowOpacity = 0.4
        formView.layer.shadowRadius = 5
        formView.layer.shadowOffset = CGSizeZero
        formActive = false
        let nameTextFieldFrame = CGRect(x: 22, y: 50, width: formView.frame.width - 44, height: 33)
        nameTextField = MDTextField(frame: nameTextFieldFrame)
        nameTextField.floatingLabel = true
        nameTextField.label = "Full Name"
        nameTextField.highlightColor = UIColor(colorLiteralRed: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        formView.addSubview(nameTextField)
        for i in 1...3 {
            let label = UILabel(frame: CGRect(x: 22, y: 83 + 57 * i, width: 200, height: 60))
            switch i {
            case 1:
                label.text = "Negative"
            case 2:
                label.text = "Neutral"
            case 3:
                label.text = "Positive"
            default:
                break
            }
            label.font = label.font.fontWithSize(18)
            formView.addSubview(label)
            let option: MDSwitch = MDSwitch(frame: CGRect(x: Int(formView.frame.width) - 100, y: 83 + 60 * i, width: 100, height: 50))
            switches.append(option)
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("switched:"))
            option.addGestureRecognizer(tapGestureRecognizer)
            option.thumbOff = UIColor.blackColor().colorWithAlphaComponent(0.5)
            formView.addSubview(option)
            option.tag = i
            if i == 1 { option.on = true }
        }
        
        let finishButton = MDButton(frame: CGRect(x: formView.bounds.width / 2 - 50, y: formView.frame.height - 50 - 10, width: 100, height: 27), type: .Raised, rippleColor: nil)
        let blue = UIColor(colorLiteralRed: 38 / 255, green: 133 / 255, blue: 169 / 255, alpha: 1)
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 27))
        label.text = "FINISH"
        label.textColor = UIColor.whiteColor()
        label.font = label.font.fontWithSize(13)
        label.textAlignment = .Center
        finishButton.addSubview(label)
        finishButton.backgroundColor = blue
        formView.addSubview(finishButton)
        finishButton.addTarget(self, action: Selector("finished"), forControlEvents: .TouchUpInside)
    }
    
    func switched(recognizer: UITapGestureRecognizer) {
        performSelector(Selector("switchedDelayed:"), withObject: recognizer, afterDelay: 0.01)
    }
    
    func finished() {
        formActive = false
        var option: Opinion = .neutral
        let name = nameTextField.text
        for sw in switches {
            if sw.on {
                switch sw.tag {
                case 1:
                    option = .negative
                case 2:
                    option = .neutral
                case 3:
                    option = .positive
                default:
                    break
                }
            }
        }
        let durationInSeconds = (UIApplication.sharedApplication().delegate as! AppDelegate).lastInterval
        let duration = secondsToString(durationInSeconds)
        nameTextField.text = ""
        for option in switches {
            option.on = option.tag == 1
        }
        PoliticallService.sharedService.reportCall(userData.userID, duration: duration, pickedUp: durationInSeconds > 10, name: name, phoneNumber: lastPhoneNumber, opinion: option) { (success) in
            if success {
                if durationInSeconds > 10 {
                    self.userData.pickedCalls += 1
                } else {
                    self.userData.droppedCalls += 1
                }
                self.userData.totalCalls += 1
                self.updateLabels()
                PoliticallService.sharedService.getAverageCallDurationForUser(self.userData.userID, completion: { (success, seconds) in
                    if success {
                        self.userData.averageCallDuration = seconds
                        self.updateLabels()
                        print("Complete Success!!! WOOHOO")
                    } else {
                        print("Failed to get average duration after new call reported")
                    }
                })
            } else {
                print("Failed to post report")
            }
        }
    }
    
    func secondsToString(numseconds: Int) -> String {
        let seconds = numseconds % 60
        let minutes = numseconds / 60
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    func switchedDelayed(recognizer: UITapGestureRecognizer) {
        let option = recognizer.view! as! MDSwitch
        if !option.on {
            option.on = true
        } else {
            for other in switches {
                if other.tag != option.tag {
                    other.on = false
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInView(view)
            if CGRectContainsPoint(phoneView.frame, location) {
                PoliticallService.sharedService.getCallNumber({ (success, number) in
                    if success {
                        let url = "tel:" + number
                        self.lastPhoneNumber = number
                        self.formActive = true
                        UIApplication.sharedApplication().openURL(NSURL(string: url)!)
                    } else {
                        print("Failed to get new #")
                        let alert = UIAlertController(title: "Ran Out Of Numbers", message: "Come back another time to support your candidate", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: false, completion: { 
                            
                        })
                    }
                })
            } else if formActive && CGRectContainsPoint(cancelView.frame, touch.locationInView(formView)) {
                nameTextField.text = ""
                for option in switches {
                    option.on = option.tag == 1
                }
                formActive = false
            }
        }
        
        view.endEditing(true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboard.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as! LeaderboardCell
        let person = leaderboard[indexPath.row]
        cell.nameLabel.text = "\(indexPath.row + 1). \(person.name)"
        cell.valueLabel.text = "\(person.value)"
        return cell
    }
}

struct LeaderboardPerson {
    var name: String
    var value: Int
}

struct UserData {
    var totalCalls: Int
    var pickedCalls: Int
    var droppedCalls: Int
    var userID: String
    var averageCallDuration: Int // in seconds
}
