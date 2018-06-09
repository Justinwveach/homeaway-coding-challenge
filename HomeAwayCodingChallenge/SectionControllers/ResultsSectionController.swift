//
//  EventSectionController.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import Foundation
import IGListKit
import STXImageCache

class ResultsSectionController: ListSectionController {
    
    var searchResults: SearchResults!
    var delegate: LoadItemsDelegate?
    
    override init() {
        super.init()
        supplementaryViewSource = self
    }
    
    convenience init(delegate: LoadItemsDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 80)
    }
    
    
    override func numberOfItems() -> Int {
        return searchResults.results.getItems().count + 1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCellFromStoryboard(
            withIdentifier: "resultCollectionViewCellIdentifier",
            for: self,
            at: index) as? ResultCollectionViewCell else {
                fatalError()
        }
        
        let count = searchResults.results.getItems().count
        if index == count {
            var titleText = "Load More Items"
            var subTitleText = "\(searchResults.results.getTotalItems()) Total Items"
            
            // Would display a different cell (or none at all) for appropriate scenarios
            // But for our purposes, this will do
            if count == 0 {
                titleText = "No Items Found"
                subTitleText = "Try modifying your search."
            }
            else if searchResults.results.getTotalItems() == index {
                titleText = "All Items Loaded"
            }
            
            if !searchResults.results.isPageable() && count > 0 {
                titleText = "All Items Loaded"
                subTitleText = ""
            }
            
            cell.titleLabel.text = titleText
            cell.locationLabel.text = subTitleText
            cell.dateLabel.text = ""
            cell.mainImageView.image = nil
            cell.favoriteImageView.image = nil
            
            return cell
        }
        
        let searchResult = searchResults.results.getItems()[index]
        
        cell.titleLabel.text = searchResult.getTitle()
        cell.locationLabel.text = searchResult.getThirdInfo()
        cell.dateLabel.text = searchResult.getSecondaryInfo()
        
        if let url = searchResult.getThumbnailUrl() {
            cell.mainImageView.stx.image(atURL: url)
            _ = cell.mainImageView.stx.image(atURL: url, placeholder: #imageLiteral(resourceName: "ic_placeholder"), progress: { progress in
                // update progressView
            }, completion: { image, _ in
                // do image processing
                return image
            })
        } else {
            cell.mainImageView.image = #imageLiteral(resourceName: "ic_placeholder")
        }
        
        cell.favoriteImageView.image = nil
        FavoriteStore.shared.checkFavorite(id: searchResult.getUniqueId()) { isFavorite in
            if isFavorite {
                cell.favoriteImageView.image = #imageLiteral(resourceName: "ic_heart")
            }
        }
        
        return cell
    }
    
    override func didUpdate(to object: Any) {
        searchResults = object as? SearchResults
    }
    
    override func didSelectItem(at index: Int) {
        if index < searchResults.results.getItems().count {
            // note: Would probably push a respective view controller for each SearchResultType (e.g. Event, Venue, or Performer. Another option would be to have a container inside the Details controller that loads the appropraite VC there.
            let detailsViewController = DetailsViewController(nibName: "DetailsViewController", bundle: nil)
            detailsViewController.searchResult = searchResults.results.getItems()[index]
            viewController?.navigationController?.pushViewController(detailsViewController, animated: true)
        } else {
            delegate?.loadMoreItems(for: searchResults)
        }
    }
    
}

extension ResultsSectionController: ListSupplementaryViewSource {
    
    func supportedElementKinds() -> [String] {
        return [UICollectionElementKindSectionHeader]
    }
    
    func viewForSupplementaryElement(ofKind elementKind: String, at index: Int) -> UICollectionReusableView {
        switch elementKind {
        case UICollectionElementKindSectionHeader:
            return userHeaderView(atIndex: index)
        default:
            fatalError()
        }
    }
    
    func sizeForSupplementaryView(ofKind elementKind: String, at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 40)
    }
    
    // MARK: - Private
    private func userHeaderView(atIndex index: Int) -> UICollectionReusableView {
        guard let view = collectionContext?.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
                                                                             for: self,
                                                                             nibName: "HeaderView",
                                                                             bundle: nil,
                                                                             at: index) as? HeaderView else {
                                                                                fatalError()
        }
        view.headerLabel.text = searchResults.header
        return view
    }
    
}
