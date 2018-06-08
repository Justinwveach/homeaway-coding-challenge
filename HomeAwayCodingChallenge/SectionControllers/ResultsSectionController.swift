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
    
    override init() {
        super.init()
        supplementaryViewSource = self
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 80)
    }
    
    
    override func numberOfItems() -> Int {
        return searchResults.items.count
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCellFromStoryboard(
            withIdentifier: "resultCollectionViewCellIdentifier",
            for: self,
            at: index) as? ResultCollectionViewCell else {
                fatalError()
        }
        
        let searchResult = searchResults.items[index]
        
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
        // note: Would probably push a respective view controller for each SearchResultType (e.g. Event, Venue, or Performer. Another option would be to have a container inside the Details controller that loads the appropraite VC there.
        let detailsViewController = DetailsViewController(nibName: "DetailsViewController", bundle: nil)
        detailsViewController.searchResult = searchResults.items[index]
        viewController?.navigationController?.pushViewController(detailsViewController, animated: true)
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
