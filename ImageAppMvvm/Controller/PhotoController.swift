import UIKit

class PhotoController: UIView {
    // MARK: - UI Components
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        return tableView
    }()
    
    // MARK: - ViewModel
    private var viewModel = PhotoViewModel()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        bindViewModel()
        viewModel.fetchPhotos()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        bindViewModel()
        viewModel.fetchPhotos()
    }

    // MARK: - Setup UI
    private func setup() {
        addSubview(tableView)
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.onPhotosFetchSuccess = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        viewModel.onPhotosFetchFailure = { errorMessage in
            DispatchQueue.main.async {
                print("Error: \(errorMessage)")
                // Display error message to the user (optional)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension PhotoController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }

        if let photoDetails = viewModel.photo(at: indexPath.row) {
            cell.configure(with: photoDetails) { [weak self] url, completion in
                self?.viewModel.loadImage(from: url, completion: completion)
            }
        }

        return cell
    }
}
