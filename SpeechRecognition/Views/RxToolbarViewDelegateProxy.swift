//
//  RxToolbarViewDelegateProxy.swift
//  SpeechRecognition
//
//  Created by 程庆春 on 2017/4/2.
//  Copyright © 2017年 Qiun Cheng. All rights reserved.
//

import RxSwift
import RxCocoa

class RxToolbarViewDelegateProxy : DelegateProxy, ToolBarViewDelegate, DelegateProxyType {

    static func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let toolbarView = object as! ToolBarView
        return toolbarView.delegate
    }

    static func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        let toolbarView = object as! ToolBarView
        toolbarView.delegate = delegate.map({ $0 as! ToolBarViewDelegate })
    }
}

extension ToolBarView {
    func createRxDelegateProxy() -> RxToolbarViewDelegateProxy {
        return RxToolbarViewDelegateProxy.init(parentObject: self)
    }
}

extension Reactive where Base: ToolBarView {
    internal var delegate: DelegateProxy {
        return RxToolbarViewDelegateProxy.proxyForObject(self.base)
    }

    internal func setDelegate(_ delegate: ToolBarViewDelegate) -> Disposable {
        return RxToolbarViewDelegateProxy.installForwardDelegate(delegate, retainDelegate: false, onProxyForObject: self.base)
    }

    var buttonTap: ControlEvent<(RecordState)> {
        return ControlEvent<(RecordState)>(events: self.delegate.methodInvoked(#selector(ToolBarViewDelegate.toolBarView(_:speedButtonSelected:))).map({ _ in
            return RecordState.unrecord
        }))
    }
}
