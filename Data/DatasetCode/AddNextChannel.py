# -*- coding: utf-8 -*-
"""
Created on 2018年3月6日
write into txt_file
"""

import MySQLCon
import numpy as np
import types
import codecs
import logging

#解决中文编码
import sys
reload(sys)
sys.setdefaultencoding('utf-8')


class Next:
    #参数列表
    def __init__(self):
        #获取数据库连接对象
        self.databaseName = 'eventwatch'
        self.myMySQLCon = MySQLCon.MySQLConnect(self.databaseName)

        self.dataTable = '20140801to20140831nyunew'
        self.outputfile = r'C:\Work\IPTV\Data\DatasetCode\201408NYUWithNext.txt'#输出txt文件的绝对地址

        self.timeGap = 20  # 20s间隔用于划分是否一次停机（无下一频道）
        self.sql = ""
        self.withNextChannel = []  # 列表：记录当前设备号添加了NextChannel的所有记录数，withnextChannel[i]表示第i条添加了NextChannel一栏的记录

    #执行sql语句、返回结果
    def Excute(self):
        dataset = self.myMySQLCon.Execute(self.sql)
        return dataset

    #循环取出每个DeviceId的使用记录，按时间排序，并添加NextChannel
    def LoadResualt(self):
        self.sql = "SELECT DISTINCT DeviceId as DeviceIds FROM " + self.dataTable + " ORDER BY DeviceId"
        DeviceIds = self.Excute()
        c = 0
        for Did in DeviceIds:
            if Did[0] != '': #防止设备id为空
                DeviceId = Did[0]  # 如'{F14D0073-0C3F-4C68-8AEE-B598B1A0569C}'
                #日志操作
                logging.info( "deviceId %d:%s is Adding Next Channel.." % (c,DeviceId) )
                print "deviceId %d:%s is Adding Next Channel.." % (c,DeviceId)

                #TIME_TO_SEC仅将时间格式改为秒，过滤掉日期，ms改为s 且把7月份的数据删掉
                self.sql = "SELECT TIME_TO_SEC(OriginTime) as seconds,OriginTime,DeviceId,ChannelNumber,FLOOR(Duration/1000)" + \
                           " FROM " + self.dataTable + \
                           " WHERE DeviceId = '" + DeviceId + "' AND date_format(OriginTime,'%Y-%m') = '2014-08' ORDER BY OriginTime"
                datasets = self.Excute()
                self.AddNextChannel(datasets)
                c = c + 1

    #给设备每条记录追加NextChannel
    def AddNextChannel(self, datasets):
       # print datasets
        seconds = np.array([x[0] for x in datasets])
        channel = np.array([x[3] for x in datasets])
        duration = np.array([x[4] for x in datasets])
        del self.withNextChannel[:]  # 清空list,释放内存
        # len(seconds)为该设备的记录数
        for i in range(len(seconds)):#i=0~len(second)-1
            self.withNextChannel.append([])#声明列表
            # 防止最后一条记录
            if i != (len(seconds) - 1):
                temp = seconds[i]+duration[i]
                #跨天，23：59：59 = 86399
                if temp >= 86400 - self.timeGap:
                    temp = temp - 86400
                totalSec = seconds[i + 1] - temp

                #与下一频道间隔20s以内，
                if (totalSec < self.timeGap) & (totalSec >= 0):
                    for j in range(1, len(datasets[i])):
                        if type(datasets[i][j]) is types.FloatType:
                            self.withNextChannel[i].append(str(int(datasets[i][j])))
                        else:
                            self.withNextChannel[i].append(datasets[i][j])
                    self.withNextChannel[i].append(channel[i + 1])

                else:#20s以外视作为关机
                    for j in range(1, len(datasets[i])):
                        if type(datasets[i][j]) is types.FloatType:
                            self.withNextChannel[i].append(str(int(datasets[i][j])))
                        else:
                            self.withNextChannel[i].append(datasets[i][j])
                    self.withNextChannel[i].append('0')

            else: #该用户最后一条
                for j in range(1, len(datasets[i])):
                    if type(datasets[i][j]) is types.FloatType:
                        self.withNextChannel[i].append(str(int(datasets[i][j])))
                    else:
                        self.withNextChannel[i].append(datasets[i][j])
                self.withNextChannel[i].append('0')

        self.writeToFile() #写入txt文件

    def writeToFile(self):
        #print 'start write'
        logging.info('start write')
        c = 0
        output = codecs.open(self.outputfile, 'a+')
        for i in self.withNextChannel:
            c = c + 1
            for j in range(len(i)):
                output.writelines(str(i[j]))
                output.writelines('\t')
            output.writelines('\n')
        output.close()
        #print 'write over...'
        logging.info('write over...')


    #TODO 将withNext输出文件导入数据库


if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG,
                        format='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s',
                        datefmt='%a, %d %b %Y %H:%M:%S',
                        filename='C:\\Work\\IPTV\\Data\\DatasetCode\\ChannelNext.log',
                        filemode='w')
    myNext = Next()
    myNext.LoadResualt()
