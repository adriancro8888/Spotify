//
//  LibraryAlbumsViewController.swift
//  Spotify
//
//  Created by Amr Hossam on 23/09/2021.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {

    
    
    private var albums = [Album]()
    private let noAlbumsView = ActionLabelView()

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(
            SearchResultSubtitleTableViewCell.self,
            forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier
        )
        tableView.isHidden = true
        return tableView
    }()
    
    private var observer: NSObjectProtocol?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        setupNoAlbumsView()
        fetchData()
        observer = NotificationCenter.default.addObserver(
            forName: .albumSavedNotification,
            object: nil,
            queue: .main,
            using: {[weak self] _ in
                self?.fetchData()
                
            })

    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noAlbumsView.frame = CGRect(x: (view.width - 150)/2, y: (view.height - 150)/2, width: 150, height: 150)
        tableView.frame = view.bounds
    }
    
    private func updateUI() {
        if albums.isEmpty {
            // Show label
            noAlbumsView.isHidden = false
            tableView.isHidden = true
        }
        
        else {
            // Show table
            tableView.reloadData()
            noAlbumsView.isHidden = true
            tableView.isHidden = false
        }
    }
    
    private func setupNoAlbumsView() {
        noAlbumsView.configure(
            with:
                ActionLabelViewViewModel(
                    text: "You haven't saved any Albums yet",
                    actionTitle: "Browse"
                )
        )
        view.addSubview(noAlbumsView)
        noAlbumsView.delegate = self
        
    }
    
    private func fetchData() {
        albums.removeAll()
        APICaller.shared.getCurrentUserAlbums { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let albums):
                    self?.albums = albums
                    self?.updateUI()

                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    
}





extension LibraryAlbumsViewController: ActionLabelViewDelegate {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        tabBarController?.selectedIndex = 0
    }
}


extension LibraryAlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else {
            return UITableViewCell()
        }
        let album = albums[indexPath.row]
        cell.configure(with: SearchResultSubtitleTableViewCellViewModel(title: album.name, subtitle: album.artists.first?.name ?? "Unknown Artist", imageURL: URL(string: album.images.first?.url ?? "")))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let album = albums[indexPath.row]
        let vc = AlbumViewController(album: album)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

