/******************************************************************************
 ** auth: liukai
 ** date: 2017/7
 ** ver : 1.0
 ** desc:  说明
 ** Copyright © 2017年 尧尚信息科技(wwww.yourshares.cn). All rights reserved
 ******************************************************************************/
import Moya

extension Response {

	public func mapAny<T: Any>() throws -> T {

		var json: Any!

		do {
			json = try mapJSON()
		} catch {
			throw(error)
		}

		guard let obj = json as? T else {
			throw Moya.MoyaError.jsonMapping(self)
		}
		return obj
	}

	public func mapAnyArray<T: Any>() throws -> [T] {

		var json: Any!

		do {
			json = try mapJSON()
		} catch {
			throw(error)
		}

		guard let array = json as? [T] else {
			throw Moya.MoyaError.jsonMapping(self)
		}
		return array

	}

}
