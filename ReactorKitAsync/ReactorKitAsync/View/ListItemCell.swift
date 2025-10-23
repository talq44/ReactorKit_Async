import UIKit
import SnapKit
import Kingfisher

final class ListItemCell: UICollectionViewCell {
    private enum Metric {
        static let spacing: CGFloat = 4
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.spacing
        
        return stackView
    }()
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subTitleLabel)
        
        stackView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(imageView.snp.width)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
    }
    
    func bind(state: ListViewState.Item) {
        imageView.kf.setImage(with: URL(string: state.imageUrl))
        titleLabel.text = state.title
        subTitleLabel.text = state.subTitle
    }
}
