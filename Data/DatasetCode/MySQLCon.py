# -*- coding: utf-8 -*-
"""
Created on 2018年3月5日
连接MySQL数据库
"""

import MySQLdb

class MySQLConnect:
    def __init__(self,databaseName):
        self.databaseName = databaseName
        # 打开数据库连接
        self.db =  MySQLdb.connect('127.0.0.1','root','123456',self.databaseName)
        # 使用cursor()方法获取操作游标
        self.cursor = self.db.cursor()

    def Execute(self,sql):
        # 执行SQL语句
        self.cursor.execute(sql)
        # 获取所有记录列表
        data = self.cursor.fetchall()
        # 提交到数据库执行
        self.db.commit()

        return data

    def __del__( self ):
        # 关闭数据库连接
        self.db.close()

# if __name__ == "__main__":
#     sql1 = "SELECT * FROM fromnyuiuse3000deviceid"
#     DeviceIds =  MySQLConnect('eventwatch',sql1)
#     print DeviceIds
#
#     for Did in DeviceIds:
#         print Did[0]
#         print len(Did)
#     print len(DeviceIds)
