//
//  ViewController.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import UIKit
import IGListKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var collectionView: ListCollectionView!
    
    lazy var searchBar = UISearchBar(frame: .zero)

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    var searchResults = [ListDiffable]()
    var typeAheadSearch = TypeAheadSearch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchBar.placeholder = "Search"
        searchBar.showsCancelButton = true
        searchBar.tintColor = UIColor(red: 0.0, green: (122.0/255.0), blue: (255.0/255.0), alpha: 1.0)

        navigationItem.titleView = searchBar
        navigationController?.navigationBar.backItem?.title = ""
        navigationItem.largeTitleDisplayMode = .never
        
        collectionView.register(UINib(nibName: "ResultCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "resultCollectionViewCellIdentifier")
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        configureTypeAhead()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadCells()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func configureTypeAhead() {
        // This is where we could configure an API to call a certain endpoint with our search text.
        // We could also search TicketMaster or provide a url for SeatGeek that will give recommendations instead of a query results
        let eventApi = SeatGeekAPI(baseURL: "\(seatgeekApiUrl)\(SearchResultType.event.rawValue)?client_id=\(seatgeekClientId)", type: .event)
        let venueApi = SeatGeekAPI(baseURL: "\(seatgeekApiUrl)\(SearchResultType.venue.rawValue)?client_id=\(seatgeekClientId)&q=", type: .venue)
        let performerApi = SeatGeekAPI(baseURL: "\(seatgeekApiUrl)\(SearchResultType.performer.rawValue)?client_id=\(seatgeekClientId)&q=", type: .performer)
        
        typeAheadSearch.add(api: eventApi)
        //typeAheadSearch.add(api: venueApi)
        //typeAheadSearch.add(api: performerApi)
        
        typeAheadSearch.delegate = self
        searchBar.delegate = typeAheadSearch
    }
    
    fileprivate func reloadCells() {
        DispatchQueue.main.async {
            self.adapter.performUpdates(animated: true, completion: nil)
            self.adapter.collectionView?.reloadItems(at: self.adapter.collectionView?.indexPathsForVisibleItems ?? [])
        }
    }

}

extension SearchViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return searchResults
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return ResultsSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
//        let view = NoContentView.instanceFromNib() as! NoContentView
//        view.set(title: "No recipes...", subTitle: "")
//        return view
        
        return nil
    }
    
}

extension SearchViewController: TypeAheadSearchDelegate {
    
    func queried<T>(items: [T]) {
            // Don't remove what has already been searched for
            if items.count == 0 {
                return
            }
            
            if let events = items as? [Event] {
                let newSearchResults = SearchResults(results: items as! [SearchResult], header: "Events")
                self.searchResults = [newSearchResults]
                
            }
            else if let venues = items as? [Venue] {
                
            }
            else if let performers = items as? [Performer] {
                
            }
        
        reloadCells()
    }
    
    func canceledSearch() {
        
    }
    
}

