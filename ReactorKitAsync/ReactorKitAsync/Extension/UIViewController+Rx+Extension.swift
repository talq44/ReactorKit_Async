import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UIViewController {
    var viewDidLoad: ControlEvent<Void> {
        let source = self.sentMessage(#selector(UIViewController.viewDidLoad))
            .map { _ in () }
        return ControlEvent(events: source)
    }
    
    var viewWillAppear: ControlEvent<Bool> {
        let source = self.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .compactMap { $0.first as? Bool }
        return ControlEvent(events: source)
    }
    
    var viewDidAppear: ControlEvent<Bool> {
        let source = self.sentMessage(#selector(UIViewController.viewDidAppear(_:)))
            .compactMap { $0.first as? Bool }
        return ControlEvent(events: source)
    }
    
    var viewWillDisappear: ControlEvent<Bool> {
        let source = self.sentMessage(#selector(UIViewController.viewWillDisappear(_:)))
            .compactMap { $0.first as? Bool }
        return ControlEvent(events: source)
    }
    
    var viewDidDisappear: ControlEvent<Bool> {
        let source = self.sentMessage(#selector(UIViewController.viewDidDisappear(_:)))
            .compactMap { $0.first as? Bool }
        return ControlEvent(events: source)
    }
    
    var viewWillAppearVoid: ControlEvent<Void> {
        let source = viewWillAppear.map { _ in () }
        return ControlEvent(events: source)
    }
    
    var viewDidAppearVoid: ControlEvent<Void> {
        let source = viewDidAppear.map { _ in () }
        return ControlEvent(events: source)
    }
    
    var viewWillDisappearVoid: ControlEvent<Void> {
        let source = viewWillDisappear.map { _ in () }
        return ControlEvent(events: source)
    }
    
    var viewDidDisappearVoid: ControlEvent<Void> {
        let source = viewDidDisappear.map { _ in () }
        return ControlEvent(events: source)
    }
}
