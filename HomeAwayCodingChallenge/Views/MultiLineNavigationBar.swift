//
//  MultiLineNavigationBar.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//


import UIKit

class MultiLineNavigationBar: UINavigationBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureView()
    }
    
    fileprivate func configureView() {
        if !prefersLargeTitles {
            return
        }
        
        // NavigationBar with large titles doesn't appear to support multi line labels yet
        // Hacky way to prevent cutting off the title
        // If not desired, could add a view to the navigation bar's titleView and then resize as necessary
        var count = 0
        var titleLabel: UILabel?
        for item in(subviews) {
            for sub in item.subviews{
                if sub is UILabel{
                    if count == 1 {
                        break;
                    }
                    titleLabel = sub as? UILabel
                    titleLabel!.numberOfLines = 0
                    titleLabel!.lineBreakMode = .byWordWrapping
                    
                    count = count + 1
                }
            }
            
        }
        self.layoutIfNeeded()

        // self.navigationController?.navigationBar.layoutSubviews()
        UIView.animate(withDuration: 0.25, animations: {
            self.layoutIfNeeded()
        })
    }
    
}
