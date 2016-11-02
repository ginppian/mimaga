//
//  pruebaViewController.swift
//  mimaga
//
//  Created by ginppian on 01/11/16.
//  Copyright © 2016 ginppian. All rights reserved.
//

import UIKit

class pruebaViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }    }


}
