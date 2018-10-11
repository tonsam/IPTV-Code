# -*- coding: utf-8 -*-
"""
Created on 2018年3月6日
获取Duration在[durationmin,durationmax]之间的记录
@author: captain
"""

import MySQLCon
import numpy as np
import datetime
import os
class ExtractDataByDuration:

    # 区间为[durationmin,durationmax],单位为s
    def __init__(self,durationMin = 600,durationMax = 3600,Trainingsetdir = r'./output/Trainingset'):
        # 获取数据库连接对象
        self.databaseName = 'eventwatch'
        self.myMySQLCon = MySQLCon.MySQLConnect(self.databaseName)
        # 参数列表
        self.nextChannelTable = '201408nyuwithnext3000' #需要从中提取的next表
        self.durationMin = durationMin
        self.durationMax = durationMax
        self.deviceIdsFileName = r'./input/DeviceIdList.txt' #需要提取的数据的DeviceId列表
        self.outputFileName1 = r'./output/201408nyuwithnextbyduration['+ str(self.durationMin) + '-' + str(self.durationMax) + '].txt'
        self.outputFileName2 = Trainingsetdir+'/TrainingsetWithDuration['+ str(self.durationMin) + '-' + str(self.durationMax) + '].txt'
        self.Did = 0 #给设备id重新编号

    # 筛选出每个设备的记录并调用删除操作
    def LoadResualt(self):
        deviceIdsFile = open(self.deviceIdsFileName)
        for line in deviceIdsFile.readlines():
            DeviceId = line.split() #转成字符串
            sql = "SELECT * FROM "+self.nextChannelTable+" WHERE DeviceId = '" + DeviceId[0] + "' ORDER BY OriginTime"
            datasets = self.myMySQLCon.Execute(sql)
            if datasets:
                self.Did += 1
                print "Writing Device%d:%s" % (self.Did,DeviceId[0])
                datasets = np.array(datasets)
                self.DeleteByDuration(datasets)

    # 对该设备，进行记录筛选操作
    def DeleteByDuration(self,datasets):
        deleteRecord = [] #需要删除的记录编（行）号
        needToChangei = -1 #上一个可能需要修改NextChannel的记录,-1为没有
        totalRecord = len(datasets)
        for i in range(totalRecord):
            #NextChannel为0的情况
            if i != totalRecord - 1 :
                if datasets[i][4] == '0':
                    datasets[i][4] = datasets[i+1][2]
            else:
                datasets[i][4] = datasets[i][2]
            #删除不符合并保持连续性
            duration = int(datasets[i][3])
            if (duration > self.durationMax) | (duration < self.durationMin):
                deleteRecord.append(i)
                if needToChangei != -1 :
                    datasets[needToChangei][4] = datasets[i][4]
            else:
                needToChangei = i
        n = datasets
        #注！！！反向遍历，删除list
        for i in deleteRecord[::-1]:
            #print i
            n = np.delete(n,i,0)#删除n的第i行
        # self.WriteToFile1(n)
        self.WriteToFile2(n)


    # #直接筛选后原格式输出
    # def WriteToFile1(self,n):
    #     output = open(self.outputFileName1, 'a+')
    #     for i in n:
    #         for j in range(len(i)):
    #             output.writelines(i[j])
    #             output.writelines('\t')
    #         output.writelines('\n')
    #     output.close()
    #

    #按训练模型要求格式输出
    def WriteToFile2(self,n):
        output = open(self.outputFileName2, 'a+')
        for i in n:
            #设备id
            output.writelines(str(self.Did))
            output.writelines('\t')
            #当前频道
            output.writelines(i[2])
            output.writelines('\t')
            #下一频道
            output.writelines(i[4])
            output.writelines('\t')
            #日期
            tdate = datetime.datetime.strptime(i[0], "%Y-%m-%d %H:%M:%S")
            output.writelines(str(tdate.day))
            output.writelines('\t')

            output.writelines('\n')
        output.close()


if __name__ == "__main__":
    extactOption = input("please input extactOption for [durationMin,durationMax]: \n 0.仅此区间；\n 1.由固定间隔Step划分区间;\n 2.左延伸型，起点不变，终点按步长step右移;\n 3.右延伸型，终点不变，起点按步长step左移;\n")
    durationMin = input("please input durationMin(s,>5s):")
    durationMax = input("please input durationMax(s):")
    #频繁连接mysql数据库会报错，(2003, "Can't connect to MySQL server on '127.0.0.1' (10048)")，解决方法：http://m.111cn.net/art-61993.html
    #0.仅此区间；
    if extactOption == 0:
        myChooseDataByDuration = ExtractDataByDuration(durationMin, durationMax)
        print 'Collecting Data Within [' + str(durationMin) + '-' + str(durationMax) + ']....'
        myChooseDataByDuration.LoadResualt()
    else:
        step = input("please input step(s):")
        #设置输出文件夹
        directory = r'./output/Trainingset'+str(extactOption)+'Stepby'+str(step)+'['+ str(durationMin) + '-' + str(durationMax) + ']'
        if not os.path.exists(directory):
            os.makedirs(directory)

        #1.由固定间隔Step划分区间;
        if extactOption == 1:
            durationLeft = durationMin
            while durationLeft + step <=durationMax:
                myChooseDataByDuration = ExtractDataByDuration(durationLeft, durationLeft+step,directory)
                print 'Collecting Data Within [' + str(durationLeft) + '-' + str(durationLeft+step) + ']....'
                myChooseDataByDuration.LoadResualt()
                durationLeft += step
        # 2.延伸型，起点不变，终点按步长step右移;
        if extactOption == 2:
            durationRight = durationMin + step
            while durationRight<=durationMax :
                myChooseDataByDuration = ExtractDataByDuration(durationMin, durationRight,directory)
                print 'Collecting Data Within [' + str(durationMin) + '-' + str(durationRight) + ']....'
                myChooseDataByDuration.LoadResualt()
                durationRight += step
        # 3.右延伸型，终点不变，起点按步长step左移;
        if extactOption == 3:
            durationLeft = durationMax - step
            while durationLeft >= durationMin:
                myChooseDataByDuration = ExtractDataByDuration(durationLeft, durationMax, directory)
                print 'Collecting Data Within [' + str(durationLeft) + '-' + str(durationMax) + ']....'
                myChooseDataByDuration.LoadResualt()
                durationLeft -= step