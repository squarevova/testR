//
//  ViewController.swift
//  TestR
//
//  Created by Volodymyr Milichenko on 28/11/2025.
//

import UIKit

class ViewController: UIViewController {
    // MARK: UI properties
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

    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add", for: .normal)
        button.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        
        return button
    }()

    // MARK: - Private properties

    private var counter: Int = 0

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue

        setupViews()
        layouViews()
    }

    // MARK: - Private methods

    private func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(addButton)
    }

    private func layouViews() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 150),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - Actions

    @objc private func addTapped() {
        counter += 1

        collectionView.reloadData()
        let indexPath = IndexPath(item: counter - 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        counter
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
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard counter > 0 else { return }

        counter -= 1
        collectionView.deleteItems(at: [indexPath])
    }
}

