//
//  PackagesViewController.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 18.02.2023.
//

import Foundation
import UIKit
import SnapKit
import NavigationLayer
import ProjectQ_Components
import ModuleAssembler

protocol PackagesViewControllerPublicInterface: AnyObject {
    func setState(_ state: PackagesViewController.State)
}



protocol PackagesViewControllerInterfaceContract: AnyObject {}

class PackagesViewController: UIViewController, Completionable, AssemblableView {
    enum EventOutputEvent {
        case some
    }
    
    enum DelegateEvent {
        case didSelectPackage(TaskPackage)
        case didRemovePackage(TaskPackage)
        case didSelectAtIndex(Int)
    }
    
    enum State {
        case loading
        case results(TaskPackages)
        case noResults
    }
    
    typealias EventOutputReturnType = EventOutputEvent
    typealias InterfaceContractType = PackagesViewControllerPublicInterface
    
    var completion: ((DelegateEvent) -> Void)?
    unowned private(set) var publicInterface: PackagesViewControllerPublicInterface!
    var eventOutput: ((EventOutputReturnType) -> Void)?
    
    required init() {
        super.init(nibName: nil, bundle: nil)
        self.publicInterface = self
        configureTableView()
        configureLoaderView()
        configureNoResultsLabel()
        
        toolbarItems = [
            .init(barButtonSystemItem: .add, target: nil, action: nil)
        ]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isToolbarHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // state
    private var packages: [TaskPackage] = []
    
    // stateless
    private let loaderView = UIActivityIndicatorView(style: .large)
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    private let noResultsLabel = UILabel()
    
    private let menu = UIMenu(title: "", children: [
        UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up"), handler: { _ in
            // Handle share action
        }),
        UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { _ in
            // Handle delete action
        })
    ])
}

private extension PackagesViewController {
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tableView.register(
            DoubleTitleTableViewCell.self,
            forCellReuseIdentifier: "cell")
    }
    
    func configureLoaderView() {
        view.addSubview(loaderView)
        loaderView.snp.makeConstraints {
            $0.center.edges.equalToSuperview()
        }
        loaderView.startAnimating()
        loaderView.isHidden = true
    }
    
    func configureNoResultsLabel() {
        view.addSubview(noResultsLabel)
        noResultsLabel.snp.makeConstraints {
            $0.center.edges.equalToSuperview()
        }
        noResultsLabel.text = "No results..."
        noResultsLabel.textAlignment = .center
        noResultsLabel.isHidden = true
    }
}

extension PackagesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        completion?(.didSelectPackage(packages[indexPath.row]))
        completion?(.didSelectAtIndex(indexPath.row))
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(
            style: .destructive,
            title: "Delete"
        ) {
            [unowned self] contextualAction, view, boolValue in
            self.completion?(
                .didRemovePackage(packages[indexPath.row])
            )
        }
        return .init(actions: [delete])
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return packages.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath) as! DoubleTitleTableViewCell
        let package = self.packages[indexPath.row]
        cell.textLabel?.text = package.name
        cell.detailTextLabel?.text = "Tasks: \(package.tasks.count)"
        return cell
    }
    
    func tableView(
        _ tableView: UITableView,
        contextMenuConfigurationForRowAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        let menuConfiguration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            return self.menu
        }
        return menuConfiguration
    }
    
    func tableView(
        _ tableView: UITableView,
        willPerformPreviewActionForRowAt indexPath: IndexPath,
        with animator: UIContextMenuInteractionCommitAnimating
    ) {
        // Handle preview action
    }
    
    func tableView(
        _ tableView: UITableView,
        willCommitMenuWithAnimator animator: UIContextMenuInteractionCommitAnimating
    ) {
        // Handle selected action
    }
}

extension PackagesViewController: PackagesViewControllerPublicInterface {
    func setState(_ state: State) {
        switch state {
        case .loading:
            noResultsLabel.isHidden = true
            loaderView.isHidden = false
            self.packages.removeAll()
            
        case .noResults:
            noResultsLabel.isHidden = false
            loaderView.isHidden = true
            self.packages.removeAll()
        
        case .results(let packages):
            noResultsLabel.isHidden = true
            loaderView.isHidden = true
            self.packages = packages
        }
        
        self.tableView.reloadData()
    }
}
