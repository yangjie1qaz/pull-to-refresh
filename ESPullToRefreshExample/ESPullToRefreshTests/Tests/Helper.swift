//
//  Helper.swift
//  ESPullToRefreshExample
//
//  Created by Jyggalag on 2017/7/24.
//  Copyright © 2017年 egg swift. All rights reserved.
//

import Dispatch

func dispatchSafeAfter(_ interval: Double, execute work: @escaping () -> Void) {
	DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: work)
}
