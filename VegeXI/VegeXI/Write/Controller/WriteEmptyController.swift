//
//  WriteEmptyController.swift
//  VegeXI
//
//  Created by 천지운 on 2020/08/07.
//  Copyright © 2020 TeamSloth. All rights reserved.
//

import UIKit

class WriteEmptyController: UIViewController {
    
    // MARK: - Properties
    
    var returnMethod: (() -> ())?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        returnMethod?()
    }
    
    // MARK: - Helpers
    
    
}
