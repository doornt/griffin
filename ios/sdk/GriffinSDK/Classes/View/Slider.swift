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
        pageControl.pageIndicatorTintColor = Utils.hexString2UIColor("#565657")
        pageControl.currentPageIndicatorTintColor = .white
        return pageControl
    }()
    
    private lazy var _scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false // must set or will have white space when dragging
        scrollView.delegate = self
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        
        return scrollView
    }()
    
    private var _singleView: UIView?
    
    private var _interval:CGFloat = 3000
    var interval:CGFloat {
        get {
            return _interval
        }
        set {
            _interval = newValue
        }
    }
    
    private var _autoPlay:Bool = false
    var autoPlay:Bool {
        get {
            return _autoPlay
        }
        set {
            _autoPlay = newValue
            (_autoPlay && _totalPage > 1) ? _startTimer() : _stopTimer()
        }
    }
    
    private var _totalPage = 0
    private var _currentPage = 0
    private var _prePage = -1
    private var _nextPage = 1
    
    private var _timer: Timer?
    
    private var _leftView: UIView?
    private var _middleView: UIView?
    private var _rightView: UIView?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        _singleView?.frame = CGRect.init(x: 0, y: 0, width: self.gnWidth, height: self.gnHeight)
        
        if (_totalPage > 1) {
            _pageControl.gnCenterX = self.gnCenterX
            _pageControl.gnBottom = 10
            
            _scrollView.contentSize = CGSize.init(width: 3 * frame.size.width, height: frame.size.height)
            _scrollView.frame = CGRect.init(x: 0, y: 0, width: self.gnWidth, height: self.gnHeight)
            
            _leftView?.frame = CGRect.init(x: 0, y: 0, width: self.gnWidth, height: self.gnHeight)
            _middleView?.frame = CGRect.init(x: self.gnWidth, y: 0, width: self.gnWidth, height: self.gnHeight)
            _rightView?.frame = CGRect.init(x: 2 * self.gnWidth, y: 0, width: self.gnWidth, height: self.gnHeight)
            
            _scrollView.setContentOffset(CGPoint.init(x: gnWidth, y: 0), animated: false)
        }
    }
    
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
                _singleView = itemViews.first!
                self.addSubview(_singleView!)
                _singleView!.frame = bounds
                return
            }
            
            _scrollView.contentSize = CGSize.init(width: 3 * frame.size.width, height: frame.size.height)
            _totalPage = _itemViews.count
            _scrollView.frame = bounds
            self.addSubview(_scrollView)
            
            for item in _itemViews {
                _scrollView.addSubview(item)
            }
            _leftView = _itemViews[_totalPage-1]
            _leftView?.frame = CGRect.init(x: 0, y: 0, width: self.gnWidth, height: self.gnHeight)
            
            _middleView = _itemViews[0]
            _middleView?.frame = CGRect.init(x: self.gnWidth, y: 0, width: self.gnWidth, height: self.gnHeight)
            
            _rightView = _itemViews[1]
            _rightView?.frame = CGRect.init(x: 2 * self.gnWidth, y: 0, width: self.gnWidth, height: self.gnHeight)
            
            _scrollView.setContentOffset(CGPoint.init(x: gnWidth, y: 0), animated: false)
            
            self.addSubview(_pageControl)
            _pageControl.numberOfPages = _totalPage
            _pageControl.gnCenterX = self.gnCenterX
            _pageControl.gnBottom = 10
            _pageControl.currentPage = 0
            
            autoPlay ? _startTimer() : _stopTimer()
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
        _currentPage += withOffset + _totalPage
        _currentPage %= _totalPage
        _prePage = (_currentPage - 1 + _totalPage) % _totalPage
        _nextPage = (_currentPage + 1) % _totalPage
        
        _pageControl.currentPage = _currentPage
        
        _scrollView.setContentOffset(CGPoint.init(x: self.gnWidth, y: 0), animated: false)
        
        _leftView = itemViews[_prePage]
        _middleView = itemViews[_currentPage]
        _rightView = itemViews[_nextPage]
        
        _leftView?.frame = CGRect.init(x: 0, y: 0, width: self.gnWidth, height: self.gnHeight)
        _middleView?.frame = CGRect.init(x: self.gnWidth, y: 0, width: self.gnWidth, height: self.gnHeight)
        _rightView?.frame = CGRect.init(x: 2 * self.gnWidth, y: 0, width: self.gnWidth, height: self.gnHeight)
    }
    
    // MARK: - Timer
    
    private func _startTimer() {
        _timer = Timer.init(timeInterval: TimeInterval(_interval / 1000), target: self, selector: #selector(_beginAutoPlay), userInfo: nil, repeats: true)
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
        _reset(withOffset: NSInteger(scrollView.contentOffset.x / self.gnWidth) - 1)
        
        if autoPlay {
            _startTimer()
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        _reset(withOffset: 1)
    }
}

class SliderView : DivView {
    
    private lazy var _slider: Slider? = {
        
        let slider = Slider.init(frame: CGRect.zero)
        
        return slider
    }()
    
    private var _interval:CGFloat = 3000
    
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
        }
    }
    
    override func updateProps(_ props: Dictionary<String, Any>) {
        super.updateProps(props)
        
        if let interval = props.toCGFloat(key: "interval"){
            self._interval = interval
            
        }
        
        if let autoplay = props.toBool(key: "auto-play"){
            self._autoPlay = autoplay
        }
    }
    
    override func loadView() -> UIView {
        return _slider!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _slider?.interval = _interval
        _slider?.autoPlay = _autoPlay
    }
    
    override func addChildren(_ children: [ViewComponent?]) {
        assert(Thread.current == Thread.main, "addChildren must be called in main thread")
        
        var childViews = [UIView]()
        
        for c in children {
            if let component = c {
                childViews.append(component.view)
                component.parent = self
                self.children.append(component)
                component.ignoreLayout = true
            }
        }
        _slider?.itemViews = childViews
        
        self._needsLayout = true
    }
}
