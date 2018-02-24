//
//  GoalSettingViewController.swift
//  DigitalNomad
//
//  Created by Presto on 2018. 2. 24..
//  Copyright © 2018년 MokMinSimSeo. All rights reserved.
//

import UIKit
import Firebase
import RealmSwift

class GoalSettingViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var labelWhoseNomadLife: UILabel!
    @IBOutlet var labelWhoseGoal: UILabel!
    @IBOutlet var textFieldNomadPlace: UITextField!
    @IBOutlet var textFieldNomadDays: UITextField!
    @IBOutlet var textFieldNomadWorkingDays: UITextField!
    @IBOutlet var textFieldBudget: UITextField!
    @IBOutlet var textFieldOneDayExpense: UITextField!
    
    let realm = try! Realm()
    var object: Results<GoalListRealm>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        object = realm.objects(GoalListRealm.self)
        textFieldNomadPlace.addBorderBottom(height: 1.0)
        textFieldNomadDays.addBorderBottom(height: 1.0)
        textFieldNomadWorkingDays.addBorderBottom(height: 1.0)
        textFieldBudget.addBorderBottom(height: 1.0)
        textFieldOneDayExpense.addBorderBottom(height: 1.0)
        let name = Auth.auth().currentUser?.displayName ?? "사용자"
        labelWhoseNomadLife.text = name + "님의 유목생활"
        labelWhoseGoal.text = name + "님의 목표"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func clickAddGoal(_ sender: UIButton) {
        let alert = UIAlertController(title: "목표 추가", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "목표"
        }
        let yesAction = UIAlertAction(title: "확인", style: .default) { (action) in
            if let text = alert.textFields?.first?.text {
                if(self.realm.objects(ProjectRealm.self).count == 0){
                    addGoalList(text, 0, Date(), 0)
                } else {
                    let pid = (self.realm.objects(ProjectRealm.self).last?.id)! + 1
                    addGoalList(text, 0, Date(), pid)
                }
            }
        }
        let noAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        present(alert, animated: true)
    }
    
    @IBAction func finishGoalSetting(_ sender: UIButton) {
        //ProjectRealm 저장
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
}


extension GoalSettingViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalSettingCell")!
        cell.textLabel?.text = object[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return object.count
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let buttonDelete = UITableViewRowAction(style: .default, title: "삭제") { (action, indexPath) in
            let result = self.object[indexPath.row]
            let deleteRow = self.object.filter("goal = '"+result.name+"'")
            try! self.realm.write{
                self.realm.delete(deleteRow)
                tableView.reloadData()
            }
        }
        return [buttonDelete]
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
extension GoalSettingViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
