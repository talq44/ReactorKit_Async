import UIKit
import SnapKit
import ReactorKit
import RxSwift
import RxCocoa

final class ListViewController: UIViewController {
    private let collectionView = UICollectionView()
    
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
