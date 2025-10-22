import UIKit
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa

final class ListViewController: UIViewController {
    typealias Cell = UICollectionViewCell
    
    var disposeBag = DisposeBag()
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    )
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        return refreshControl
    }()
    private let indicatorView = UIActivityIndicatorView(style: .large)
    private let emptyImage = UIImageView(
        image: UIImage(systemName: "exclamationmark.magnifyingglass")
    )
    
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
        view.addSubview(indicatorView)
        view.addSubview(emptyImage)
        
        collectionView.snp.makeConstraints { make in
            make.directionalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        indicatorView.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
        emptyImage.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.refreshControl = refreshControl
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
        rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .do(onNext: { [weak self] _ in
                self?.refreshControl.beginRefreshing()
            })
            .map { Reactor.Action.refresh}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(ListViewState.Item.self)
            .map { Reactor.Action.selectItem(id: $0.id) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        collectionView.rx.willDisplayLastItem(in: 0)
            .map { Reactor.Action.more }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: ListViewReactor) {
        reactor.state.map { $0.items }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                self?.refreshControl.endRefreshing()
            })
            .bind(to: collectionView.rx.items(
                cellIdentifier: String(describing: Cell.self),
                cellType: Cell.self
            )) { _, _, _ in
                
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.isShowLoading }
            .distinctUntilChanged()
            .map { !$0 }
            .bind(to: indicatorView.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isShowEmpty }
            .distinctUntilChanged()
            .map { !$0 }
            .bind(to: emptyImage.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .distinctUntilChanged()
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] message in
                self?.showAlert(message: message)
            })
            .disposed(by: disposeBag)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "확인",
            style: .default,
            handler: { _ in
                
            }
        ))
        present(alert, animated: true)
    }
}
