//
//  Slider.swift
//  GriffinSDK
//
//  Created by sampson on 2018/1/21.
//  Copyright © 2018年 com.doornt. All rights reserved.
//

import Foundation

class Slider: UIView, UIScrollViewDelegate {
    
    private lazy var _pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = .white
        pageControl.currentPageIndicatorTintColor = .black
        return pageControl
    }()
    
    private lazy var _scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.delegate = self
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        return scrollView
    }()
    
    private var _totalPage = 0
    private var _currentPage = 0
    private var _prePage = -1
    private var _nextPage = 1
    
    private var _timer: Timer?
    
    private var _leftView: UIView?
    private var _middleView: UIView?
    private var _rightView: UIView?
    
    private var _itemViews: [UIView] = [UIView]()
    var itemViews: [UIView] {
        get {
            return _itemViews
        }
        
        set {
            _itemViews = newValue
            
            if itemViews.count <= 0 {
                return
            }
            
            if itemViews.count == 1 {
                let view = itemViews.first!
                self.addSubview(view)
                view.frame = self.frame
                return
            }
            
            self.addSubview(_pageControl)
            _pageControl.numberOfPages = _totalPage
            _pageControl.gnCenterX = self.gnCenterX
            _pageControl.gnBottom = 10
            
            _scrollView.contentSize = CGSize.init(width: 3 * frame.size.width, height: frame.size.height)
            _totalPage = _itemViews.count
            _scrollView.frame = frame
            self.addSubview(_scrollView)
            
            for item in _itemViews {
                _scrollView.addSubview(item)
            }
            _leftView = _itemViews[_totalPage-1]
            _leftView?.frame = frame
            
            _middleView = _itemViews[0]
            _middleView?.frame = CGRect.init(x: self.gnWidth, y: 0, width: self.gnWidth, height: self.gnHeight)
            
            _rightView = _itemViews[1]
            _rightView?.frame = CGRect.init(x: 2 * self.gnWidth, y: 0, width: self.gnWidth, height: self.gnHeight)
            
            _scrollView.setContentOffset(CGPoint.init(x: gnWidth, y: 0), animated: false)
            
            _startTimer()
        }
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        _stopTimer()
    }
    
    private func _reset(withOffset: NSInteger) {
        _prePage = _currentPage
        _currentPage += withOffset
        _currentPage %= _totalPage
        _nextPage = (_currentPage + 1) % _totalPage
        
        _scrollView.setContentOffset(CGPoint.init(x: self.gnWidth, y: 0), animated: false)
        
        _leftView = itemViews[_prePage]
        _middleView = itemViews[_currentPage]
        _rightView = itemViews[_nextPage]
        
        _leftView?.frame = frame
        _middleView?.frame = CGRect.init(x: self.gnWidth, y: 0, width: self.gnWidth, height: self.gnHeight)
        _rightView?.frame = CGRect.init(x: 2 * self.gnWidth, y: 0, width: self.gnWidth, height: self.gnHeight)
    }
    
    // MARK: - Timer
    private func _startTimer() {
        _timer = Timer.init(timeInterval: 3.0, target: self, selector: #selector(_beginAutoPlay), userInfo: nil, repeats: true)
        RunLoop.current.add(_timer!, forMode: .commonModes)
    }
    
    private func _stopTimer() {
        if _timer != nil {
            _timer?.invalidate()
            _timer = nil
        }
    }
    
    @objc func _beginAutoPlay() {
        _scrollView.setContentOffset(CGPoint.init(x: 2 * gnWidth, y: 0), animated: true)
    }
    
    // MARK: - ScrollViewDelegate
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        _stopTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
        _reset(withOffset: NSInteger(scrollView.contentOffset.x / self.gnWidth) - 1)
        _startTimer()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        _reset(withOffset: 1)
    }
}

class SliderView : DivView {
    
    private var _interval:CGFloat?
    
    private var _autoPlay:Bool = false
    
    required init(ref: String, styles: Dictionary<String, Any>,props:Dictionary<String, Any>) {
        super.init(ref: ref, styles: styles, props: props)
    }
    
    
    override var styles: Dictionary<String, Any>{
        get{
            return super.styles
        }
        set{
            super.styles = newValue
            
            if let interval = newValue.toCGFloat(key: "interval"){
                self._interval = interval
            }
            
            if let autoplay = newValue.toBool(key: "auto-play"){
                self._autoPlay = autoplay
            }
        }
    }
    
    
}
