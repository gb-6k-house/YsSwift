/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc: 互斥锁
 ** Copyright © 2017年 尧尚信息科技(www.yourshares.cn). All rights reserved
 ******************************************************************************/

import Foundation

public final class Lock {
    var mutex = UnsafeMutablePointer<pthread_mutex_t>.allocate(capacity: 1)
    
    init() { pthread_mutex_init(mutex, nil) }
    
    deinit {
        pthread_mutex_destroy(mutex)
        mutex.deinitialize()
        mutex.deallocate(capacity: 1)
    }
    
    /// In critical places it's better to use lock() and unlock() manually
    func sync<T>(_ closure: () -> T) -> T {
        pthread_mutex_lock(mutex)
        defer { pthread_mutex_unlock(mutex) }
        return closure()
    }
    
    func lock() { pthread_mutex_lock(mutex) }
    func unlock() { pthread_mutex_unlock(mutex) }
}
