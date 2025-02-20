//
//  ViewController.swift
//  tableViewTodo
//
//  Created by Alley Pereira on 15/02/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
	
	private let table: UITableView = {
		let table = UITableView()
		table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
		return table
	}()

	var items = [String]()
	
	//	override func loadView() {
	//		super.loadView()
	//		self.view = table
	//	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.items = UserDefaults.standard.stringArray(forKey: "items") ?? []
		title = "To Do List"
		view.addSubview(table)
		table.dataSource = self
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
															target: self, action: #selector(didTapAdd))
	}
	@objc private func didTapAdd() {
		let alert = UIAlertController(title: "New Item", message: "Enter new to do list item!", preferredStyle: .alert)
		alert.addTextField { (field) in
			field.placeholder = "Enter item..."
		}

		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

		alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] (_) in
			if let field = alert.textFields?.first {
				if let text = field.text, !text.isEmpty {

					DispatchQueue.main.async {
						var currentItems = UserDefaults.standard.stringArray(forKey: "items") ?? []
						currentItems.append(text)
						UserDefaults.standard.setValue(currentItems, forKey: "items")
						self?.items.append(text)
						self?.table.reloadData()
					}
				}
			}
		}))

		present(alert, animated: true)

	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		table.frame = view.bounds // fica por cima da view que ja existia
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

		cell.textLabel?.text = items[indexPath.row]
		return cell
	}
}
