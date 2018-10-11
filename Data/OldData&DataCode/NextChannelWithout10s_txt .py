# -*- coding: utf-8 -*-
"""
Created on Thu Apr 14 15:54:06 2016

@author: captain
"""

import MySQLCon
import numpy as np

DatabaseName = 'eventclientchannel'

def open_file(filename):
    print "start load ..."
    files = open(filename)
    print "file load over..."
    return files
#筛选出每个设备的记录
def LoadResualt(files):
    c = 0
    for line in files.readlines():
        print c
        DeviceId = line.split()
        sql = "SELECT * FROM 201408nyumapnextout10s WHERE DeviceId = '"+ DeviceId[0] + "' ORDER BY OriginTime"
        datasets = MySQLCon.MySQLConnect(DatabaseName,sql)
        c = c+1
        datasets = np.array(datasets)
        delete10s(datasets)

#对该设备，进行记录筛选操作
def delete10s(datasets):  
    delete_local = []
    gap1 = 0
    gap2 = 0
    j = -2
    totalRecord = len(datasets)
    for i in range(totalRecord):
        duration = int(datasets[i][3])
        #第一条记录0
        if ((i==0)&(duration<=10)):
            delete_local.append(0)

        if((i-j)==1):
            gap1 = gap1+1
        if((i-j)!=1):
            gap1 = 0
        if((i!=0)&(duration<=15)):
            datasets[i-1-gap1][4] = datasets[i][4]
            delete_local.append(i)
            j = i

    n = datasets
    #print delete_local
    for i in delete_local:
        n = np.delete(n,(i-gap2),0)
        gap2 = gap2+1
    writeToFile(n)

def writeToFile(n):
    print 'start write'
    output = open(r'F:\IPTV\dataset\201408nyuwithnextout10m.txt','a+')
    for i in n:
        #print c
        #c = c+1
        for j in range(len(i)):
            output.writelines(i[j])
            output.writelines('\t')
        output.writelines('\n')
    output.close()
    print 'write over...'

files = open_file(r'F:\IPTV\dataset\matlabdeviceid3000.txt')
datasets = LoadResualt(files)
            
            