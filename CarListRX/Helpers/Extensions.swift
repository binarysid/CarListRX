//
//  Extensions.swift
//  Cars
//
//  Created by Linkon Sid on 11/12/22.
//
import UIKit
import RxSwift
import RxCocoa
extension UIViewController: loadingViewable {}

extension Reactive where Base: UIViewController {
    
    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
    public var isAnimating: Binder<Bool> {
        return Binder(self.base, binding: { (vc, active) in
            if active {
                vc.startAnimating()
            } else {
                vc.stopAnimating()
            }
        })
    }
    
}
extension UIView {
    @IBInspectable public var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            layer.borderColor = color.cgColor
        }
    }
    
    /// : Border width of view; also inspectable from Storyboard.
    @IBInspectable public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    /// Corner radius of view; also inspectable from Storyboard.
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
    /// : Shadow color of view; also inspectable from Storyboard.
    @IBInspectable public var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    /// : Shadow offset of view; also inspectable from Storyboard.
    @IBInspectable public var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    /// : Shadow opacity of view; also inspectable from Storyboard.
    @IBInspectable public var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    /// : Shadow radius of view; also inspectable from Storyboard.
    @IBInspectable public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    func fillToSuperView(){
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        }
    }
    var screen : CGRect {
        get {
            return UIScreen.main.bounds
        }
    }
    
    // src : https://medium.com/@sdrzn/adding-gesture-recognizers-with-closures-instead-of-selectors-9fb3e09a8f0b
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
}

extension UITableView {
    func registerReusableCell<T: UITableViewCell>(_: T.Type) where T: ReusableCell {
        if let nib = T.nib {
            self.register(nib, forCellReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableCell<T: UITableViewCell>(indexPath: IndexPath) -> T where T: ReusableCell {
        return self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }
    
    func registerReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) where T: ReusableCell {
        if let nib = T.nib {
            self.register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T? where T: ReusableCell {
        return self.dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as! T?
    }
    func removeEmptyCells(){
        self.tableFooterView = UIView()
    }
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
    func reloadSection(section:Int){
        UIView.setAnimationsEnabled(false)
        self.beginUpdates()
        self.reloadRows(at: [IndexPath(row: 0, section: section)], with: .automatic)
        self.reloadSections([section], with: .automatic)
        self.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    func indexPathIsValid(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}
protocol ReusableCell: AnyObject {
    static var reuseIdentifier: String { get }
    static var nib: UINib? { get }
}

extension ReusableCell {
    static var reuseIdentifier: String { return String(describing: self) }
    static var nib: UINib? { return nil }
}
extension UIImageView {
    func loadFrom(URLAddress: String) {
        guard let url = URL(string: URLAddress) else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadedImage = UIImage(data: imageData) {
                        self?.image = loadedImage
                }
            }
        }
    }
}
extension String{
    var data:Data? {
        get{
            guard let url = URL(string: self) else {
                return nil
            }
            if let infoData = try? Data(contentsOf: url) {
                return infoData
            }
            return nil
        }
    }
}
extension String {
    public enum DateType {
        case isoDateTimeSec
        case dmy
        case localDateTimeSec
        
        var stringFormat:String {
          switch self {
          case .isoDateTimeSec: return "yyyy-MM-dd'T'HH:mm:ssZ"
          case .dmy: return "dd.MM.yyyy HH:mm"
          case .localDateTimeSec: return "yyyy-MM-dd HH:mm:ss"
          }
        }
 }
        
 func toDate(_ format: DateType = .dmy) -> Date?{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.stringFormat
        let date = dateFormatter.date(from: self)
        return date
  }
 }
//extension Data: ExpressibleByStringLiteral{
//    public init(stringLiteral value: StaticString) {
//        guard let url = URL(string: String(describing: value)) else {
//            return
//        }
////        let imageData = try? Data(contentsOf: url)
//        try! self.init(contentsOf: url)
//
//    }
//}


extension Date{
    func getDateOfMonth()->Int{
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.day, from: self)
        return weekDay
    }
    func getTime()->(hour:Int,minute:Int,second:Int){
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        let minutes = calendar.component(.minute, from: self)
        let seconds = calendar.component(.second, from: self)
        return (hour,minutes,seconds)
    }
    func getMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    func getYearByComparingToCurrent()->String{
        let currentDate = Date()
        let calendar = Calendar.current
        let currDatecomponents = calendar.dateComponents([.year], from: currentDate)
        let givenDateComponents = calendar.dateComponents([.year], from: self)
        guard let currentYear = currDatecomponents.year, let givenYear = givenDateComponents.year,currentYear != givenYear else{
            return ""
        }
        return String(givenYear)
    }
}
