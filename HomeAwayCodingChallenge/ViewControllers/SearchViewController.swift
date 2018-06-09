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
    
    var eventSection = SearchResults(results: SeatGeekResults(), header: "Events", type: .event)
    var performerSection = SearchResults(results: SeatGeekResults(), header: "Performers", type: .performer)
    var venueSection = SearchResults(results: SeatGeekResults(), header: "Venues", type: .venue)
    
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
        
        searchResults.append(eventSection)
        searchResults.append(performerSection)
        searchResults.append(venueSection)
        
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
        let venueApi = SeatGeekAPI(baseURL: "\(seatgeekApiUrl)\(SearchResultType.venue.rawValue)?client_id=\(seatgeekClientId)", type: .venue)
        let performerApi = SeatGeekAPI(baseURL: "\(seatgeekApiUrl)\(SearchResultType.performer.rawValue)?client_id=\(seatgeekClientId)", type: .performer)
        
        typeAheadSearch.add(api: eventApi)
        typeAheadSearch.add(api: venueApi)
        typeAheadSearch.add(api: performerApi)
        
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
        
        return ResultsSectionController(delegate: self)
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
//        let view = NoContentView.instanceFromNib() as! NoContentView
//        view.set(title: "No recipes...", subTitle: "")
//        return view
        
        return nil
    }
    
}

extension SearchViewController: TypeAheadSearchDelegate {
   
    func queried<T>(results: T) where T : Pagination, T : ResultList {
        DispatchQueue.main.async { [unowned self] in
            if results.getItems().count == 0 {
                //return
            }
            
            var type: SearchResultType = .event
            if let _ = results.getItems() as? [Event] {
                type = .event
                self.eventSection.results = results as! BaseSearchResult
            }
            else if let _ = results.getItems() as? [Performer] {
                type = .performer
                self.performerSection.results = results as! BaseSearchResult
            }
            else if let _ = results.getItems() as? [Venue] {
                type = .venue
                self.venueSection.results = results as! BaseSearchResult
            }

            self.collectionView.reloadSections(NSIndexSet(index: type.sectionOrder()) as IndexSet)

        }
    }
    
    fileprivate func delete(indexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            self.collectionView.performBatchUpdates({ () -> Void in
                self.collectionView.deleteItems(at: indexPaths)
            }, completion: nil)
        }
    }
    
    func canceledSearch() {
    
    }
    
}

extension SearchViewController: LoadItemsDelegate {
    
    func loadMoreItems(for results: SearchResults) {
        let api = SeatGeekAPI(baseURL: "\(seatgeekApiUrl)\(results.type.rawValue)?client_id=\(seatgeekClientId)", type: results.type)
        let r = results.results
        
        if r.isPageable() {
            api.queryItems(with: r.getSearchString(), params: ["per_page": "\(r.getPageSize())", "page": "\(r.getCurrentPage() + 1)"]) { [weak self] (response: SeatGeekResults) in
                DispatchQueue.main.async { [weak self] in
                    

                    guard let strongSelf = self else {
                        return
                    }
                    
                    //
                    let indexPaths = strongSelf.getIndexPathsToUpdate(currentCount: results.results.getItems().count, additionalItems: response.getItems().count, max: response.getTotalItems(), section: results.type.sectionOrder())
                    
                    results.results.append(items: response.getItems())
                    if let existing = results.results as? SeatGeekResults {
                        existing.metadata = response.metadata
                    }
                
                    strongSelf.collectionView.performBatchUpdates({ () -> Void in
                        strongSelf.collectionView.insertItems(at: indexPaths as [IndexPath])
                    }, completion:nil)
                }
            }
        }
    }
    
    fileprivate func getIndexPathsToUpdate(currentCount: Int, additionalItems: Int, max: Int, section: Int) -> [IndexPath] {
        var indexPaths = [NSIndexPath]()
        for i in currentCount..<(currentCount + additionalItems) {
            if i > (max - 1) {
                break
            }
            indexPaths.append(NSIndexPath(row: i, section: section))
        }
        
        return indexPaths as [IndexPath]
    }
}

