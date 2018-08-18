//
//  LoadingViewController.swift
//  AWSAuthExample
//
//  Created by sharif ahmed on 4/7/18.
//  Copyright © 2018 sharif ahmed. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    @IBOutlet private var loadingImageView: UIImageView!
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rotateImageView()
    }
    
    // MARK: - Animation
    
    private func rotateImageView() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
            let loadingImageView = self.loadingImageView!
            loadingImageView.transform = loadingImageView.transform.rotated(by: CGFloat(Double.pi / 2))
        }) { _ in
            self.rotateImageView()
        }
    }
}
