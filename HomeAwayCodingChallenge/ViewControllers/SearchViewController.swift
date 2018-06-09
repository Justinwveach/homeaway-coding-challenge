//
//  ViewController.swift
//  HomeAwayCodingChallenge
//
//  Created by Justin Veach on 6/7/18.
//  Copyright © 2018 Justin Veach. All rights reserved.
//

import UIKit
import IGListKit


/// This view controller handles the searching for Events, Performers, and Venues.
class SearchViewController: UIViewController {
    
    @IBOutlet weak var collectionView: ListCollectionView!
    
    lazy var searchBar = UISearchBar(frame: .zero)
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    // A list of sections to display the content. [Events, Performers, Venues]
    var sections = [ListDiffable]()
    
    // This will handle the search functionality
    var typeAheadSearch = TypeAheadSearch()
    
    // Our sections that contain the search results
    var eventSection = SectionData(results: SeatGeekResults(), header: "Events", type: .event)
    var performerSection = SectionData(results: SeatGeekResults(), header: "Performers", type: .performer)
    var venueSection = SectionData(results: SeatGeekResults(), header: "Venues", type: .venue)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchBar.placeholder = "Search for Events, Performers, or Venues"
        searchBar.showsCancelButton = true
        searchBar.tintColor = UIColor(red: 0.0, green: (122.0/255.0), blue: (255.0/255.0), alpha: 1.0)

        navigationItem.titleView = searchBar
        navigationController?.navigationBar.backItem?.title = ""
        navigationItem.largeTitleDisplayMode = .never
        
        collectionView.register(UINib(nibName: "ResultCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "resultCollectionViewCellIdentifier")
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        sections.append(eventSection)
        sections.append(performerSection)
        sections.append(venueSection)
        
        configureTypeAhead()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Reloads the cells in case any items were favorited
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
        
        // Set the delegate so we can receive a callback with results
        typeAheadSearch.delegate = self
        
        // Going to let our typeAheadSearch handle the searchBar actions
        searchBar.delegate = typeAheadSearch
    }
    
    fileprivate func reloadCells() {
        // Ensure we are on the main thread if updating collection view
        DispatchQueue.main.async {
            self.adapter.performUpdates(animated: true, completion: nil)
            self.adapter.collectionView?.reloadItems(at: self.adapter.collectionView?.indexPathsForVisibleItems ?? [])
        }
    }

}

extension SearchViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return sections
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
            
            // Check to see what kind of results were returned and update our appropriate section
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

            // Update the appropriate collection view section
            self.collectionView.reloadSections(NSIndexSet(index: type.sectionOrder()) as IndexSet)

        }
    }
    
    func canceledSearch() {
        // Search was canceled so remove all the data and update the collection view.
        for section in sections {
            if let sectionData = section as? SectionData {
                sectionData.results.removeAllItems()
            }
        }
        collectionView.reloadData()
    }
    
}

extension SearchViewController: LoadItemsDelegate {
    
    // Right now, we are handling the loading of more data. In the future, I may move this to the TypeAheadSearch.
    func loadMoreItems(for section: SectionData) {
        let api = SeatGeekAPI(baseURL: "\(seatgeekApiUrl)\(section.type.rawValue)?client_id=\(seatgeekClientId)", type: section.type)
        
        // Ensure this section contains Pageable data
        if section.results.isPageable() {
            api.queryItems(with: section.results.getSearchString(), params: ["per_page": "\(section.results.getPageSize())", "page": "\(section.results.getCurrentPage() + 1)"]) { [weak self] (response: SeatGeekResults) in
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    
                    // Get the indexPaths for the additional items
                    let indexPaths = strongSelf.getIndexPathsToUpdate(currentCount: section.results.getItems().count, additionalItems: response.getItems().count, max: response.getTotalItems() + 1, section: section.type.sectionOrder())
                    
                    // Append the results
                    section.results.append(items: response.getItems())
                    if let existing = section.results as? SeatGeekResults {
                        existing.metadata = response.metadata
                    }
                
                    // Update the collection view to represent the new data
                    strongSelf.collectionView.performBatchUpdates({ () -> Void in
                        strongSelf.collectionView.insertItems(at: indexPaths as [IndexPath])
                    }, completion:nil)
                }
            }
        }
    }
    
    
    // Calculate the index paths that need to be inserted.
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

