import UIKit
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa

final class ListViewController: UIViewController {
    typealias Cell = UICollectionViewCell
    
    var disposeBag = DisposeBag()
    
    private let collectionView = UICollectionView()
    
    init(reactor: ListViewReactor) {
        super.init(nibName: nil, bundle: nil)
        
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ListViewController: ReactorKit.View {
    typealias Reactor = ListViewReactor
    
    func bind(reactor: ListViewReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: ListViewReactor) {
        collectionView.rx.modelSelected(ListViewState.Item.self)
            .map { Reactor.Action.selectItem(id: $0.id) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: ListViewReactor) {
        reactor.state.map { $0.items }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: collectionView.rx.items(
                cellIdentifier: String(describing: Cell.self),
                cellType: Cell.self
            )) { _, _, _ in
                
            }.disposed(by: disposeBag)
    }
}
