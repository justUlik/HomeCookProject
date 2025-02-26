import UIKit
import MapKit

final class AddressSuggestionsView: UIView, UITableViewDelegate, UITableViewDataSource, SearchBarViewDelegate {
    private var suggestionsTableView = UITableView()
    private var searchResults: [MKMapItem] = []
    var onAddressSelected: ((MKMapItem) -> Void)?
    internal var addressInput = SearchBarView()
    
    private enum Constants {
        static let leftOffset: CGFloat = 16
        static let addressInputTopOffset: CGFloat = 8
        static let addressInputHeight: CGFloat = 46
        static let suggestionsTableHeight: CGFloat = UIScreen.main.bounds.height * 0.7
        static let tableViewTopOffset: CGFloat = 8
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }

    private func configureUI() {
        self.backgroundColor = .backgroundBlue
        self.setHeight(Constants.suggestionsTableHeight)
        configureAddressInput()
        configureTableView()
    }

    private func configureAddressInput() {
        addSubview(addressInput)
        addressInput.pinTop(to: safeAreaLayoutGuide.topAnchor, Constants.addressInputTopOffset)
        addressInput.pinHorizontal(to: self, Constants.leftOffset)
        addressInput.setHeight(Constants.addressInputHeight)
        addressInput.backgroundColor = .customLightGray
        
        addressInput.setTextPlaceHolder(text: "")
        addressInput.becomeFirstResponder()
        
        addressInput.delegate = self
    }

    private func configureTableView() {
        addSubview(suggestionsTableView)
        suggestionsTableView.pinTop(to: addressInput.bottomAnchor, Constants.tableViewTopOffset)
        suggestionsTableView.pinHorizontal(to: self, Constants.leftOffset)
        suggestionsTableView.setHeight(Constants.suggestionsTableHeight)

        suggestionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "suggestionCell")
        suggestionsTableView.delegate = self
        suggestionsTableView.dataSource = self
        suggestionsTableView.backgroundColor = .backgroundBlue
        
        suggestionsTableView.isHidden = true
        suggestionsTableView.separatorStyle = .none
    }

    func updateSuggestions(_ results: [MKMapItem]) {
        self.searchResults = results
        suggestionsTableView.reloadData()
        suggestionsTableView.isHidden = results.isEmpty
        if !results.isEmpty {
            addressInput.becomeFirstResponder()
        }
    }



    // MARK: - UITableView Delegate & DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionCell", for: indexPath)
        let item = searchResults[indexPath.row]
        cell.textLabel?.text = item.placemark.name
        cell.backgroundColor = .backgroundBlue
        cell.textLabel?.textColor = .customBlack
        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAddress = searchResults[indexPath.row]
        onAddressSelected?(selectedAddress)
        
        addressInput.becomeFirstResponder()
    }

    // MARK: - SearchBarViewDelegate
    func searchBar(_ searchBar: SearchBarView, textDidChange text: String) {
        guard !text.isEmpty else {
            suggestionsTableView.isHidden = true
            return
        }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text
        request.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173),
            latitudinalMeters: 5000,
            longitudinalMeters: 5000
        )

        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            if error != nil {
                return
            }
            guard let response = response else { return }
            self?.updateSuggestions(response.mapItems)
        }
    }




    func searchBarShouldBeginEditing(_ searchBar: SearchBarView) -> Bool {
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: SearchBarView) {
        searchBar.endEditing(true)
        suggestionsTableView.isHidden = true
    }

}
