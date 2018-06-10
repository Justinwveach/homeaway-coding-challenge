//
//  DetailsViewController.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import UIKit
import ObjectMapper
import STXImageCache


/// This class displays the details of a SearchResult. In the future, I may add a Container View and then load the approriate ViewController for varying SearchResults.
class DetailsViewController: UIViewController {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var searchResult: SearchResult!
    var isFavorited = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // searchResult needs to be set before presenting
        assert(searchResult != nil, "DetailsViewController requires a SearchResult.")
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_heart"), style: .plain, target: self, action: #selector(favorite(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Configure our view before it is displayed
        configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        // Quick hack to make the large titles multi line
        // With more time, I would probably create a view to add the navigation bar's titleView
        var titleLabel: UILabel?
        var count = 0
        for item in(navigationController?.navigationBar.subviews)! {
            for sub in item.subviews{
                if sub is UILabel{
                    if count == 1 {
                        break;
                    }
                    titleLabel = sub as? UILabel
                    titleLabel!.numberOfLines = 0
                    titleLabel!.lineBreakMode = .byWordWrapping
                    titleLabel!.alpha = 0.0
                    count = count + 1
                }
            }
            
        }
        
        title = searchResult?.getTitle() ?? "N/A"

        UIView.animate(withDuration: 0.25) {
            titleLabel?.alpha = 1.0
            self.navigationController?.navigationBar.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc fileprivate func favorite(_ sender: Any) {
        isFavorited = !isFavorited
        FavoriteStore.shared.toggle(favorited: isFavorited, for: searchResult.getUniqueId())
        configureFavorite()
    }
    
    fileprivate func configureView() {
        FavoriteStore.shared.checkFavorite(id: searchResult.getUniqueId()) { result in
            isFavorited = result
            configureFavorite()
        }
        
        if let imageUrl = searchResult.getMainImageUrl() {
            mainImageView.stx.image(atURL: imageUrl)
        } else {
            mainImageView.image = #imageLiteral(resourceName: "img_stadium_seats")
        }
            
        dateLabel.text = searchResult.getSecondaryInfo()
        locationLabel.text = searchResult.getPrimaryInfo()
    }
    
    fileprivate func configureFavorite() {
        navigationItem.rightBarButtonItem?.tintColor = isFavorited ? .red :.lightGray
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
