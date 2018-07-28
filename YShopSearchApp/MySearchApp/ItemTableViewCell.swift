import UIKit

class ItemTableViewCell: UITableViewCell {
    @IBOutlet weak var itemImageView: UIImageView! // 商品画像
    @IBOutlet weak var itemTitleLabel: UILabel!    // 商品タイトル
    @IBOutlet weak var itemPriceLabel: UILabel!    // 商品価格
    
    @IBOutlet weak var favoriteItemImageView: UIImageView!  // お気に入り画像
    @IBOutlet weak var favoriteItemPriceLabel: UILabel!     // お気に入り価格
    @IBOutlet weak var favoriteItemTitleLabel: UILabel!     //お気に入りタイトル
    
    var itemUrl: String? // 商品ページのURL。遷移先の画面で利用する
    var favoriteItemUrl: String? // お気に入りページのURL。遷移先の画面で利用する
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        // 元々入っている画像を再利用時にクリア
        if itemImageView != nil {
            itemImageView.image = nil
        }
        if favoriteItemImageView != nil {
            favoriteItemImageView.image = nil
        }
    }

}
