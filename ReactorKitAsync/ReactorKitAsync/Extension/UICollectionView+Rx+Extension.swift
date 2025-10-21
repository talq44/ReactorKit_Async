import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UICollectionView {
    func willDisplayLastItem(in section: Int) -> Observable<Void> {
        return willDisplayCell
            .compactMap { [weak base] _, indexPath -> Void? in
                guard let collectionView = base else { return nil }
                
                guard section >= 0 && section < collectionView.numberOfSections else { return nil }
                
                let items = collectionView.numberOfItems(inSection: section)
                guard items > 0 else { return nil }
                
                let lastItem = items - 1
                guard lastItem > 0 else { return nil }
                guard indexPath.section == section && indexPath.item == lastItem else { return nil }
                
                return ()
            }
    }
}
