//
//  ViewController.swift
//  TestR
//
//  Created by Volodymyr Milichenko on 28/11/2025.
//

import UIKit

protocol ServiceProtocol {
    func addItem()
    func remove(at: Int)
}

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
        collectionView.clipsToBounds = false

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
    private var pannedCell: CustomCell?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .blue

        setupViews()
        layoutViews()
    }

    // MARK: - Private methods

    private func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(addButton)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
    }

    private func layoutViews() {
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

    private func removeItemAtIndexPath(_ indexPath: IndexPath) {
        guard counter > 0 else { return }

        counter -= 1
        collectionView.deleteItems(at: [indexPath])
    }

    // MARK: - Actions

    @objc private func addTapped() {
        counter += 1

        collectionView.reloadData()
        let indexPath = IndexPath(item: counter - 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard
                let indexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)),
                let cell = collectionView.cellForItem(at: indexPath) as? CustomCell
            else {
                return
            }

            pannedCell = cell
        case .changed:
            guard let pannedCell else { return }

            let translation = gesture.translation(in: collectionView)

            if abs(translation.y) > abs(translation.x) {
                collectionView.isScrollEnabled = false
                pannedCell.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        case .ended, .cancelled:
            defer {
                collectionView.isScrollEnabled = true
                pannedCell = nil
            }

            guard let pannedCell else { return }

            let scrollViewHeight = collectionView.bounds.height
            let cellTranslationY = pannedCell.transform.ty

            let heightDiff = (scrollViewHeight - pannedCell.bounds.height) / 2.0

            if abs(cellTranslationY) - heightDiff > pannedCell.bounds.height / 2 {
                guard let indexPath = collectionView.indexPath(for: pannedCell) else {
                    pannedCell.transform = .identity
                    return
                }

                removeItemAtIndexPath(indexPath)
            } else {
                UIView.animate(withDuration: 0.2) {
                    pannedCell.transform = .identity
                }
            }
        default:
            break
        }
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
        removeItemAtIndexPath(indexPath)
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        true
    }
}

extension ViewController: ServiceProtocol {
    func addItem() {
        DispatchQueue.main.async {
            self.addTapped()
        }
    }

    func remove(at index: Int) {
        DispatchQueue.main.async {
            guard index >= 0 && index < self.counter else {
                return
            }

            let indexPath = IndexPath(item: index, section: 0)

            self.removeItemAtIndexPath(indexPath)
        }
    }
}
