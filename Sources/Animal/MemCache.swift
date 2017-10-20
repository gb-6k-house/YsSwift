/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc: 内存中缓存数据
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/

import Foundation

public protocol Caching {
    associatedtype ItemType
    subscript(key: AnyHashable) -> ItemType? { get set }
}

public protocol CachedItem {
    var value: AnyObject {get set}
    var memCost: Int { get }
}

public final class Cache<T: CachedItem>: Caching {
//    public typealias ItemType = T
    
    
    private var map = [AnyHashable: Node<T>]()
    private let list = LinkedList<T>()
    private let lock = Lock()

    /// The maximum total cost that the cache can hold.
    public var costLimit: Int { didSet { lock.sync { trim() } } }
    
    /// The maximum number of items that the cache can hold.
    public var countLimit: Int { didSet { lock.sync { trim() } } }
    
    /// The total cost of items in the cache.
    public private(set) var totalCost = 0
    
    /// The total number of items in the cache.
    public var totalCount: Int { return map.count }
    
    
    /// Initializes `Cache`.
    /// - parameter costLimit: Default value is calculated based on the amount
    /// of the available memory.
    public init(costLimit: Int = Cache.defaultCostLimit(), countLimit: Int = Int.max) {
        self.costLimit = costLimit
        self.countLimit = countLimit
        #if os(iOS) || os(tvOS)
            NotificationCenter.default.addObserver(self, selector: #selector(removeAll), name: .UIApplicationDidReceiveMemoryWarning, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: .UIApplicationDidEnterBackground, object: nil)
        #endif
    }
    
    deinit {
        #if os(iOS) || os(tvOS)
            NotificationCenter.default.removeObserver(self)
        #endif
    }
    
    public static func defaultCostLimit() -> Int {
        let physicalMemory = ProcessInfo.processInfo.physicalMemory
        let ratio = physicalMemory <= (1024 * 1024 * 512 /* 512 Mb */) ? 0.1 : 0.2
        let limit = physicalMemory / UInt64(1 / ratio)
        return limit > UInt64(Int.max) ? Int.max : Int(limit)
    }
    
    /// Accesses the image associated with the given key.
    public subscript(key: AnyHashable) -> T? {
        get {
            lock.lock()  // faster than `sync()`
            defer { lock.unlock() }
            
            guard let node = map[key] else { return nil }
            
            // bubble node up to the head
            list.remove(node)
            list.append(node)
            
            return node.value
        }
        set {
            lock.lock() // faster than `sync()`
            defer { lock.unlock() }
            
            if let v = newValue {
                add(node: Node(value: v, key: key))
                trim()
            } else {
                guard let node = map[key] else { return }
                remove(node: node)
            }
        }
    }
    
    private func add(node: Node<T>) {
        if let existingNode = map[node.key] {
            remove(node: existingNode)
        }
        list.append(node)
        map[node.key] = node
        totalCost += node.value.memCost
    }
    
    private func remove(node: Node<T>) {
        list.remove(node)
        map[node.key] = nil
        totalCost -= node.value.memCost
    }
    
    /// Removes all cached images.
    @objc public dynamic func removeAll() {
        lock.sync {
            map.removeAll()
            list.removeAll()
            totalCost = 0
        }
    }
    
    private func trim() {
        _trim(toCost: costLimit)
        _trim(toCount: countLimit)
    }
    
    @objc private dynamic func didEnterBackground() {
        // Remove most of the stored items when entering background.
        // This behaviour is similar to `NSCache` (which removes all
        // items). This feature is not documented and may be subject
        // to change in future YSKit versions.
        lock.sync {
            _trim(toCost: Int(Double(costLimit) * 0.1))
            _trim(toCount: Int(Double(countLimit) * 0.1))
        }
    }
    
    /// Removes least recently used items from the cache until the total cost
    /// of the remaining items is less than the given cost limit.
    public func trim(toCost limit: Int) {
        lock.sync { _trim(toCost: limit) }
    }
    
    private func _trim(toCost limit: Int) {
        trim(while: { totalCost > limit })
    }
    
    /// Removes least recently used items from the cache until the total count
    /// of the remaining items is less than the given count limit.
    public func trim(toCount limit: Int) {
        lock.sync { _trim(toCount: limit) }
    }
    
    private func _trim(toCount limit: Int) {
        trim(while: { totalCount > limit })
    }
    
    private func trim(while condition: () -> Bool) {
        while condition(), let node = list.tail { // least recently used
            remove(node: node)
        }
    }
    
    
    private final class Context {
        var value: Node<T>
        var key: AnyHashable
        init(value: Node<T>, key:AnyHashable) {
            self.value = value
            self.key = key
            
        }
    }

}

/// Basic doubly linked list.
private final class LinkedList<V> {
    // head <-> node <-> ... <-> tail
    private(set) var head: Node<V>?
    private(set) var tail: Node<V>?
    
    deinit { removeAll() }
    
    /// Appends node to the head.
    func append(_ node: Node<V>) {
        if let currentHead = head {
            head = node
            currentHead.previous = node
            node.next = currentHead
        } else {
            head = node
            tail = node
        }
    }
    
    func remove(_ node: Node<V>) {
        node.next?.previous = node.previous // node.previous is nil if node=head
        node.previous?.next = node.next // node.next is nil if node=tail
        if node === head { head = node.next }
        if node === tail { tail = node.previous }
        node.next = nil
        node.previous = nil
    }
    
    func removeAll() {
        // Here's a clever trick to avoid recursive Nodes deallocation
        var node = tail
        while let previous = node?.previous {
            previous.next = nil
            node = previous
        }
        
        head = nil
        tail = nil
    }
}

private final class Node<V> {
    let value: V
    var next: Node<V>?
    weak var previous: Node<V>?
    var key: AnyHashable

    init(value: V, key: AnyHashable) {
        self.value = value
        self.key = key
        
    }
}
