//
//  ViewController.swift
//  DroidsOnRoidsRxExample#1
//
//  Created by Patrick Bellot on 1/2/17.
//  Copyright © 2017 Bell OS, LLC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
  
  // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
  
  // MARK: ivars
  var shownCities = [String]() // Data source for UITableView
  let allCities = ["New York", "London", "Oslo", "Warsaw", "Berlin", "Praga"] // mocked API data source
  
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }
  
  func setup() {
    tableView.dataSource = self
    searchBar
      .rx.text
      .filter { $0 != nil }
      .map { $0! }
      .debounce(0.5, scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .filter { $0.characters.count > 0 }
      .subscribe { [unowned self] (query) in
        self.shownCities = self.allCities.filter { $0.hasPrefix(query.element!) }
        self.tableView.reloadData()
      }
    .addDisposableTo(disposeBag)
  }
}

  // MARK: TableView Data Source
extension ViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return shownCities.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
    cell.textLabel?.text = shownCities[indexPath.row]
    
    return cell
  }
} // End of class
