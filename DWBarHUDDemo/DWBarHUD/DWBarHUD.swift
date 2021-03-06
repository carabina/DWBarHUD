//
//  DWBarHUD.swift
//  DWBarHUDDemo
//
//  Created by duwei on 2018/4/19.
//  Copyright © 2018年 Dywane. All rights reserved.
//

import UIKit

public enum DWBarAnimationType {
    case `default`
    case spring
    case fade
}

public final class DWBarHUD {
    
    /// 单例模式用于配制
    fileprivate struct Constants {
        static let sharedHUD = DWBarHUD()
    }
    
    //MARK: - Properties
    open class var sharedHUD: DWBarHUD {
        return Constants.sharedHUD
    }
    
    /// 配置类
    public var config: HUDConfig = HUDConfig()
    
    //MARK: - Public Method
    public class func showHUD(message: String, type: BarHUDType = .default) {
        sharedHUD.config.showHUD(type: type, message: message)
    }
    
    //MARK: - Private Method
    /// 在rootVC顶端页面中展示该HUD
    ///
    /// - Parameter vc: 需要展示的HUD VC
    fileprivate static func display(HUD vc: UIViewController){
        let topVC = topViewControllerOfRootViewController()
        topVC?.addChildViewController(vc)
        topVC?.view.addSubview(vc.view)
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vc.view.frame = topVC!.view.bounds
    }
}

public struct HUDConfig {
    
    // MARK: - Properties
    // MARK: - DWBarProtocol
    /// 成功状态Icon
    public var barSuccessIcon: UIImage? = DWHUDAssets.successIcon
    /// 警告状态Icon
    public var barWarningIcon: UIImage? = DWHUDAssets.warningIcon
    /// 失败状态Icon
    public var barFailedIcon: UIImage? = DWHUDAssets.failIcon
    /// 普通状态Icon
    public var barDefaultIcon: UIImage? = DWHUDAssets.defaultIcon
    /// HUD高度
    public var barHeight: CGFloat = 70
    /// 成功状态背景颜色
    public var barSuccessColor: UIColor = UIColor(red: 65/255.0, green: 190/255.0, blue: 152/255.0, alpha: 1)
    /// 失败状态背景颜色
    public var barFailedColor: UIColor = UIColor(red: 253/255.0, green: 141/255.0, blue: 163/255.0, alpha: 1)
    /// 警告状态背景颜色
    public var barWarningColor: UIColor = UIColor(red: 255/255.0, green: 204/255.0, blue: 30/255.0, alpha: 1)
    /// 普通状态背景颜色
    public var barDefaultColor: UIColor = .lightGray
    /// 提示信息字体
    public var barMessageFont: UIFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
    /// 提示信息字体颜色
    public var barMessageFontColor: UIColor = .white
    /// 是否显示icon
    public var showIcon: Bool = true
    /// HUD显示时间
    public var displayDuration: TimeInterval = 2.0
    /// HUD显示动画时长
    public var animationDuration: TimeInterval = 0.3
    /// HUD显示动画类型
    public var animationType: DWBarAnimationType = .default
    
    fileprivate func showHUD(type: BarHUDType = .default, message: String) {
        let vc = BarHUDViewController()
        vc.setup(HUDSetter: self, type: type, message: message)
        DWBarHUD.display(HUD: vc)
    }
}


// MARK: - Private Methods
extension DWBarHUD {
    
    /// 获取根控制器的顶端控制器
    ///
    /// - Returns: 根控制器的顶端控制器
    private static func topViewControllerOfRootViewController() -> UIViewController? {
        var vc = topViewController(of: UIApplication.shared.keyWindow?.rootViewController)
        while vc?.presentedViewController != nil {
            vc = topViewController(of: vc?.presentedViewController)
        }
        return topViewController(of: vc)
    }
    
    /// 获取当前parentController的顶端页面
    ///
    /// - Parameter parentViewController: 父控制器
    /// - Returns: 父控制器的顶端控制器
    private static func topViewController(of parentViewController: UIViewController?) -> UIViewController?{
        if let nav = parentViewController as? UINavigationController {  //如果是navigation controller则返回最顶端的
            return nav.topViewController
        }
        if let tab = parentViewController as? UITabBarController {  //如果是tabbar controller则返回当前选择的控制器
            return tab.selectedViewController
        }
        return parentViewController //否则返回本身
    }
    
}
