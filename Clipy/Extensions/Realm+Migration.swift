//
//  Realm+Migration.swift
//  Clipy
//
//  Created by 古林俊佑 on 2016/10/16.
//  Copyright © 2016年 Shunsuke Furubayashi. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {
    static func migration() {
        let config = Realm.Configuration(schemaVersion: 6, migrationBlock: { (migration, oldSchemaVersion) in
            if oldSchemaVersion <= 2 {
                // Add identifier in CPYSnippet
                migration.enumerate(CPYSnippet.className()) { (_, newObject) in
                    newObject!["identifier"] = NSUUID().UUIDString
                }
            }
            if oldSchemaVersion <= 4 {
                // Add identifier in CPYFolder
                migration.enumerate(CPYFolder.className()) { (_, newObject) in
                    newObject!["identifier"] = NSUUID().UUIDString
                }
            }
            if oldSchemaVersion <= 5 {
                // Update RealmObjc to RealmSwift
                migration.enumerate(CPYClip.className(), { (oldObject, newObject) in
                    newObject!["dataPath"] = oldObject!["dataPath"]
                    newObject!["title"] = oldObject!["title"]
                    newObject!["dataHash"] = oldObject!["dataHash"]
                    newObject!["primaryType"] = oldObject!["primaryType"]
                    newObject!["updateTime"] = oldObject!["updateTime"]
                    newObject!["thumbnailPath"] = oldObject!["thumbnailPath"]
                })
                migration.enumerate(CPYFolder.className(), { (oldObject, newObject) in
                    newObject!["index"] = oldObject!["index"]
                    newObject!["enable"] = oldObject!["enable"]
                    newObject!["title"] = oldObject!["title"]
                    newObject!["identifier"] = oldObject!["identifier"]
                })
                migration.enumerate(CPYSnippet.className(), { (oldObject, newObject) in
                    newObject!["index"] = oldObject!["index"]
                    newObject!["enable"] = oldObject!["enable"]
                    newObject!["title"] = oldObject!["title"]
                    newObject!["content"] = oldObject!["content"]
                    newObject!["identifier"] = oldObject!["identifier"]
                })
            }
        })
        Realm.Configuration.defaultConfiguration = config
        _ = try! Realm()
    }
}
