# -*- coding: utf-8 -*-
"""
Created on Sat Jan 30 22:46:20 2016
连接数据库函数
@author: Administrator
"""

import MySQLdb

def MySQLConnect(DatabaseName,sql):
    db = MySQLdb.connect('127.0.0.1','root','123456',DatabaseName)
    cursor = db.cursor()
    cursor.execute(sql)
    data = cursor.fetchall()
    db.commit()
    db.close
    return data

