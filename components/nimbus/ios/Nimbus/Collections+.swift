/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import Foundation

public extension Dictionary {
    func mapKeysNotNull<K1>(_ transform: (Key) -> K1?) -> [K1: Value] {
        let transformed: [(K1, Value)] = compactMap { k, v in
            transform(k).flatMap { ($0, v) }
        }
        return [K1: Value](uniqueKeysWithValues: transformed)
    }

    func mapValuesNotNull<V1>(_ transform: (Value) -> V1?) -> [Key: V1] {
        return compactMapValues(transform)
    }

    func mapNotNull<K1, V1>(_ keyTransform: (Key) -> K1?, _ valueTransform: (Value) -> V1?) -> [K1: V1] {
        let transformed: [(K1, V1)] = compactMap { k, v in
            guard let k1 = keyTransform(k),
                  let v1 = valueTransform(v)
            else {
                return nil
            }
            return (k1, v1)
        }
        return [K1: V1](uniqueKeysWithValues: transformed)
    }

    func mergeWith(_ defaults: [Key: Value], _ valueMerger: ((Value, Value) -> Value)? = nil) -> [Key: Value] {
        guard let valueMerger = valueMerger else {
            return merging(defaults, uniquingKeysWith: { overide, _ in overide })
        }

        return merging(defaults, uniquingKeysWith: valueMerger)
    }
}
