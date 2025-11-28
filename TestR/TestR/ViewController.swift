//
//  ViewController.swift
//  TestR
//
//  Created by Volodymyr Milichenko on 28/11/2025.
//

import UIKit

class ViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 100, height: 100)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue

        setupViews()
        layouViews()
    }

    private func setupViews() {
        view.addSubview(collectionView)
    }

    private func layouViews() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 150),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        10
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CustomCell.reuseIdentifier,
            for: indexPath
        ) as? CustomCell else {
            return CustomCell()
        }

        cell.backgroundColor = .yellow

        return cell
    }
}

extension ViewController: UICollectionViewDelegate {

}

