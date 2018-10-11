# -*- coding: utf-8 -*-
"""
Created on Wed Apr 13 15:23:06 2016
write into txt_file
@author: captain
"""

import MySQLCon
import numpy as np
import types
import codecs 
import logging
import sys

reload(sys)
sys.setdefaultencoding('utf-8')

class Next():

    def __init__(self):
        self.sql = ""
        self.nextChannel = []
        self.DatabaseName = 'eventclientchannel'

    def Excute(self):
        dataset = MySQLCon.MySQLConnect(self.DatabaseName,self.sql)
        return dataset
    def LoadResualt(self):
        self.sql = "SELECT DISTINCT DeviceId FROM 20140801to20140831nyu ORDER BY DeviceId"
        DeviceIds = self.Excute()
        c = 0
        for Did in DeviceIds:
            print "total deviceId:%d" % (c)
            logging.info("total deviceId:%d" % (c))
            del self.nextChannel[:]
            DeviceId = DeviceIds[c][0]
            self.sql = "SELECT TIME_TO_SEC(OriginTime) as seconds,OriginTime,DeviceId,ChannelNumber,FLOOR(Duration/1000)"+\
                    " FROM 20140801to20140831nyu WHERE DeviceId = '"+ DeviceId + "' ORDER BY OriginTime"
            datasets = self.Excute()
            #print datasets
            c = c+1
            self.AddNextChannel(datasets)

    def AddNextChannel(self,datasets):
        seconds = np.array([x[0] for x in datasets])
        channel = np.array([x[3] for x in datasets])
        duration = np.array([x[4] for x in datasets])
        #len(seconds)为该设备的记录数
        for i in range(len(seconds)):
            self.nextChannel.append([])
            #datasets[i][7].encode('utf-8')
            #防止最后一条记录
            if(i!=(len(seconds)-1)):
                totalSec = seconds[i+1]-(seconds[i]+duration[i])
                if((totalSec<20)&(totalSec>=0)):
                    for j in range(1,len(datasets[i])):
                        if type(datasets[i][j]) is types.FloatType:
                            self.nextChannel[i].append(str(int(datasets[i][j])))
                        
                        else:
                            self.nextChannel[i].append(datasets[i][j])
                    self.nextChannel[i].append(channel[i+1])
                    #nextChannel[i].append(str(i))
                else:
                    for j in range(1,len(datasets[i])):
                        if type(datasets[i][j]) is types.FloatType:
                            self.nextChannel[i].append(str(int(datasets[i][j])))
                        
                        else:
                            self.nextChannel[i].append(datasets[i][j])
                    self.nextChannel[i].append('0')
                    #nextChannel[i+lastTotalLines].append(str(i))
            else:
                for j in range(1,len(datasets[i])):
                    if type(datasets[i][j]) is types.FloatType:
                        self.nextChannel[i].append(str(int(datasets[i][j])))
                    
                    else:
                        self.nextChannel[i].append(datasets[i][j])
                self.nextChannel[i].append('0')
                #nextChannel[i+lastTotalLines].append(str(i))
        self.writeToFile()
    def writeToFile(self):
        print 'start write'
        logging.info('start write')
        c = 0
        output = codecs.open(r'F:\IPTV\dataset\201408NYUWithNext.txt','a+')
        for i in self.nextChannel:
            #print c
            c = c+1
            for j in range(len(i)):
                output.writelines(i[j])
                output.writelines('\t')
            output.writelines('\n')
        output.close()
        print 'write over...'
        logging.info('write over...')
'''
-------------主入口
'''
logging.basicConfig(level=logging.DEBUG,
                format='%(asctime)s %(filename)s[line:%(lineno)d] %(levelname)s %(message)s',
                datefmt='%a, %d %b %Y %H:%M:%S',
                filename='F:\\IPTV\\code\\ChannelNext.log',
                filemode='w')
myNext = Next()
myNext.LoadResualt()
#writeToFile(nextChannel)