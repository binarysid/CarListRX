//
//  ViewController.swift
//  Cars
//
//  Created by Linkon Sid on 11/12/22.
//

import UIKit
import RxSwift
import RxCocoa

class CarListVC: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    public var cars: PublishSubject<[ViewData]> = .init()
    private let disposeBag = DisposeBag()
    var viewModel = CarListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBindings()
    }
    private func configureBindings(){
        viewModel.loading
            .bind(to: self.rx.isAnimating).disposed(by: disposeBag)
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.tableView?.registerReusableCell(CarCell.self)
        viewModel.viewObject
            .bind(to: tableView.rx.items(cellIdentifier: CarCell.reuseIdentifier, cellType: CarCell.self)) {  (row,car,cell) in
            cell.data = car
            }.disposed(by: disposeBag)
        self.tableView.rx.modelSelected(ViewData.self).subscribe(onNext: { item in
            print("SelectedItem: \(item.title)")
        }).disposed(by: disposeBag)
        tableView.removeEmptyCells()
        viewModel.getCarListFromAPI()
    }
}

extension CarListVC:UITableViewDelegate{
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//           return 200
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30.0
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.white
//        return headerView
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
