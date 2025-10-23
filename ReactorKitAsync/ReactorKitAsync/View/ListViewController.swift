import UIKit
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa

final class ListViewController: UIViewController {
    typealias Cell = ListItemCell
    
    var disposeBag = DisposeBag()
    
    private static func createCompositionalLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .estimated(180) // 다이나믹 높이를 위한 estimated 사용
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(180) // 그룹도 estimated 높이 사용
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: ListViewController.createCompositionalLayout()
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
        
        collectionView.register(
            Cell.self,
            forCellWithReuseIdentifier: String(describing: Cell.self)
        )
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
            .do(onNext: { [weak self] _ in
                self?.refreshControl.endRefreshing()
            })
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(to: collectionView.rx.items(
                cellIdentifier: String(describing: Cell.self),
                cellType: Cell.self
            )) { index, item, cell in
                cell.bind(state: item)
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.isShowLoading }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isShowLoading in
                guard let self else { return }
                indicatorView.isHidden = !isShowLoading
                isShowLoading ? indicatorView.startAnimating() : indicatorView.stopAnimating()
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isShowEmpty }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .map { !$0 }
            .bind(to: emptyImage.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.errorMessage }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
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
