/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import UIKit
import SnapKit
import RxSwift
import MJRefresh

open class YSTableViewController: YSBaseViewController {

    public var tableViewStyle: UITableViewStyle = .plain
    var isTableViewScrolling: Bool = false
    public var tableView: UITableView!

    override open func viewDidLoad() {
        super.viewDidLoad()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override open func buildUI() {
        super.buildUI()

        self.tableView = UITableView(frame: CGRect.zero, style: self.tableViewStyle)
        self.tableView.ys.customize { (view) in

            view.estimatedRowHeight = 100
            view.rowHeight = UITableViewAutomaticDimension
            view.separatorStyle = .none
            view.delegate = self
            view.dataSource = self
            view.ys.register(UITableViewCell.self)
            view.ys.register(YSBaseTableViewCell.self)

            view.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 0.001))

            self.view.insertSubview(view, at: 0)
        }

    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.tableView.frame = self.view.bounds
    }
}

extension YSTableViewController: UITableViewDataSource, UITableViewDelegate {

    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 0
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className(), for: indexPath)
    }

    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == self.tableView {
            self.isTableViewScrolling = true
        }
    }

    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.tableView {
            self.isTableViewScrolling = false
        }
    }

}
