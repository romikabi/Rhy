//
//  MainMenuViewController.swift
//  Rhy
//
//  Created by Roman Abuzyarov on 24.03.2018.
//  Copyright © 2018 Roman Abuzyarov. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var playLabel: UILabel!
    
    @IBOutlet weak var playButton: UIButton!
    
    
    @IBAction func buttonDown(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.playButton.tintColor = UIColor.perrywinkle
        }
        UIView.transition(with: self.playLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.playLabel.textColor = UIColor.perrywinkle
        }, completion: { (b) in })
    }
    @IBAction func buttonUp(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.playButton.tintColor = UIColor.white
        }
        UIView.transition(with: self.playLabel, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.playLabel.textColor = UIColor.white
        }, completion: { (b) in })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
