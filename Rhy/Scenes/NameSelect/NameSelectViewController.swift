//
//  NameSelectViewController.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 15.04.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import UIKit

class NameSelectViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func sumbit(_ sender: Any) {
        guard var text = textField.text else { return }
        text = text.trimmingCharacters(in: [" "])
        if text.count < 5{
            return
        }
        UserDefaults.standard.set(text, forKey: "nickname")
        
        performSegue(withIdentifier: "submitNickname", sender: self)
    }
    
    @IBOutlet weak var textField: CustomTextField!
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
