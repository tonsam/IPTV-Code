%%%%%%%%%%%%%%%%%%%%%%%%%%主函数入口%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = Version1(varargin)
%VERSION1 MATLAB code file for Version1.fig
% Last Modified by GUIDE v2.5 23-Apr-2018 15:15:14
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Version1_OpeningFcn, ...
                   'gui_OutputFcn',  @Version1_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:}); %主函数
else
    gui_mainfcn(gui_State, varargin{:});
end

% End initialization code - DO NOT EDIT
%%%%%%%%%%%%%%%%%%%%%%%%%窗口初始化%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Version1_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for Version1
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes Version1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function varargout = Version1_OutputFcn(hObject, eventdata, handles)

% Get default command line output from handles structure
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%%%▼各控件的回调函数%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%---------------------神经网络选取及各种参数输入---------------------------
function RUN_button_Callback(hObject, eventdata, handles)
%读取各个输入
myGUIdata.inputDir = get(handles.edit_inputDir,'String');
myGUIdata.outputDir = get(handles.edit_outputDir,'String');
myGUIdata.UserIDBegin = str2double(get(handles.edit_UserIDBegin,'String'));
myGUIdata.UserIDEnd = str2double(get(handles.edit_UserIDEnd,'String'));
myGUIdata.windows = str2double(get(handles.edit_windows,'String'));
myGUIdata.seqlength = str2double(get(handles.edit_seqlength,'String'));
netlist = get(handles.popup_network_name,'String');
netindex = get(handles.popup_network_name,'Value');
myGUIdata.network_name = netlist{netindex};
myGUIdata.n_epoch = str2double(get(handles.edit_n_epoch,'String'));
myGUIdata.batch_size = str2double(get(handles.edit_batch_size,'String'));

handles.myGUIdata = myGUIdata;
guidata(hObject,handles);%保存
disp(handles.myGUIdata);

handles.myGUIdata.outputFile = enterRnn(handles.myGUIdata);

set(handles.ShowUserResult_button,'Enable','On')
set(handles.ShowDayResult_button,'Enable','off')
guidata(hObject,handles);%保存

%inputDir默认值设置C:\Work\IPTV\IPTV Recommendation\dataset\
function edit_inputDir_Callback(hObject, eventdata, handles)
inputDir =get(hObject,'String');
if (isempty(inputDir))
    set(hObject,'String','C:\Work\IPTV\IPTV Recommendation\dataset\');
end 

%OnputDir默认值设置C:\Work\IPTV\IPTV Recommendation\Result\
function edit_outputDir_Callback(hObject, eventdata, handles)
outputDir =get(hObject,'String');
if (isempty(outputDir))
    set(hObject,'String','C:\Work\IPTV\IPTV Recommendation\Result\');
end   

%UserIDBegin起始用户编号1
function edit_UserIDBegin_Callback(hObject, eventdata, handles)
UserIDBegin = str2double(get(hObject,'String'));
UserIDEnd = str2double(get(handles.edit_UserIDEnd,'String'));
if (isempty(UserIDBegin) || UserIDBegin<1)
    set(hObject,'String','1');
end   
if (UserIDBegin>UserIDEnd)
    set(hObject,'String',num2str(UserIDEnd));
end
%UserIDEnd最终用户编号3000
function edit_UserIDEnd_Callback(hObject, eventdata, handles)
UserIDEnd = str2double(get(hObject,'String'));
UserIDBegin = str2double(get(handles.edit_UserIDBegin,'String'));
if (isempty(UserIDEnd) || UserIDEnd>3000)
    set(hObject,'String','3000');
end 
if (UserIDBegin>UserIDEnd)
    set(hObject,'String',num2str(UserIDBegin));
end

%windows训练窗口长度7
function edit_windows_Callback(hObject, eventdata, handles)
temp = str2double(get(hObject,'String'));
if (isempty(temp))
    set(hObject,'String','7');
end 
%seqlength序列长度5
function edit_seqlength_Callback(hObject, eventdata, handles)
temp = str2double(get(hObject,'String'));
if (isempty(temp))
    set(hObject,'String','5');
end 
%network_name网络类型lstm
function popup_network_name_Callback(hObject, eventdata, handles)
%n_epoch训练期数 7
function edit_n_epoch_Callback(hObject, eventdata, handles)
temp = str2double(get(hObject,'String'));
if (isempty(temp))
    set(hObject,'String','7');
end 
%训练时batch_size大小5
function edit_batch_size_Callback(hObject, eventdata, handles)
temp = str2double(get(hObject,'String'));
if (isempty(temp))
    set(hObject,'String','5');
end 

%-------------显示（输出）该用户该月的平均推荐正确率的统计结果-------------
function ShowUserResult_button_Callback(hObject, eventdata, handles)
%所有操作显示图像在axes1控件中
axes(handles.axes1);
%原始UserID映射到结果数据集编号newUserID
SingleUserResult.ResultUserID = str2double(get(handles.edit_ResultUserID,'String'));
SingleUserResult.newResultUserID = SingleUserResult.ResultUserID - handles.myGUIdata.UserIDBegin+1;
%加载数据
disp(handles.myGUIdata.outputFile);
load(handles.myGUIdata.outputFile);
SingleUserResult.recomm5 = someOutput.recomm{1,SingleUserResult.newResultUserID};
%去除404数据
for i = 1:size(SingleUserResult.recomm5,1)
    for j = 1:size(SingleUserResult.recomm5,2)
        if SingleUserResult.recomm5(i,j) ==404 
            SingleUserResult.recomm5(i,j) =NaN;
        end
    end
end
SingleUserResult.recomm5 = SingleUserResult.recomm5';

%绘图参数如下
plot(SingleUserResult.recomm5,'-p','DisplayName','recomm5');
title(['编号为',num2str(SingleUserResult.ResultUserID),'推荐准确率结果曲线图'])%设置图像标题
xlabel('第x天测试集') %设置x轴标题
ylabel('推荐准确率') %设置y轴标题
legend('TOP1','TOP2','TOP3','TOP4','TOP5');%设置图例
set(gca,'YTick',[0:0.1:1]); %设置y轴坐标显示范围，间隔为0.1
set(gca,'XTick',[1:1:31]) %设置x轴坐标显示范围，间隔为1
%设置横坐标显示文字
xticklabel = {};
for i = handles.myGUIdata.windows+1: 32
    xticklabel = [xticklabel,{num2str(i)}];
end
set(gca,'XTickLabel',xticklabel); 

%允许进一步观看具体天数对比情况
set(handles.ShowDayResult_button,'Enable','on')
set(handles.edit_ResultDay,'Enable','on')

function edit_ResultUserID_Callback(hObject, eventdata, handles)
temp = str2double(get(hObject,'String'));
if (isempty(temp) || temp<handles.myGUIdata.UserIDBegin)
    set(hObject,'String',num2str(handles.myGUIdata.UserIDBegin));
end 
if (temp>handles.myGUIdata.UserIDEnd)
    set(hObject,'String',num2str(handles.myGUIdata.UserIDEnd));
end 

%-------------显示该用户该天的推荐预测与实际观看对比TOPn结果-------------------
function ShowDayResult_button_Callback(hObject, eventdata, handles)
%初始化--清空
set(handles.edit_TotalChanNum,'String','');
set(handles.edit_RecommChanNum,'String','');
set(handles.edit_AcceptedChanNum,'String','');
set(handles.edit_recall,'String','');
set(handles.edit_acc,'String','');
%所有操作显示图像在axes2控件中
axes(handles.axes2);cla;
set(handles.popup_TopN,'Enable','inactive');

%原始UserID映射到结果数据集编号newUserID
SingleUserResult.ResultUserID = str2double(get(handles.edit_ResultUserID,'String'));
SingleUserResult.newResultUserID = SingleUserResult.ResultUserID - handles.myGUIdata.UserIDBegin+1;
%原始DayID映射到结果数据集编号newDayID
SingleUserResult.ResultDayID = str2double(get(handles.edit_ResultDay,'String'));
SingleUserResult.newResultDayID = SingleUserResult.ResultDayID - handles.myGUIdata.windows;
%加载数据
disp(handles.myGUIdata.outputFile);
load(handles.myGUIdata.outputFile);
recommchannel = someOutput.recommchannel{SingleUserResult.newResultUserID,SingleUserResult.newResultDayID};
%检查是否有结果
if isempty(recommchannel)
    h=errordlg('错误：该天数据量不足，未发生预测，无结果！','错误');  
    hu=findall(allchild(h),'style','pushbutton');  
    set(hu,'string','确定')
    return
end
datasetorder = someOutput.datasetorder{SingleUserResult.newResultUserID,SingleUserResult.newResultDayID};
watchorder = someOutput.watchorder{SingleUserResult.newResultUserID,SingleUserResult.newResultDayID};
prediction = someOutput.prediction{SingleUserResult.newResultUserID,SingleUserResult.newResultDayID};
%获取当天的各种结果
SingleUserResult.SingleDayResult = getSDR(recommchannel,watchorder,datasetorder,prediction,handles.myGUIdata.seqlength);

%绘图参数如下
SingleUserResult.SingleDayResult.datasetorderLine = plot(SingleUserResult.SingleDayResult.datasetorder ,'--ok');
hold on;
SingleUserResult.SingleDayResult.recommchannelLine = plot(SingleUserResult.SingleDayResult.recommchannel ,'-x');
title(['用户',num2str(SingleUserResult.ResultUserID),'在第',num2str(SingleUserResult.ResultDayID ),'天实际观看与预测推荐的频道序列对比曲线图'])%设置图像标题
xlabel('第x个观看频道') %设置x轴标题
ylabel('频道号') %设置y轴标题
set(gca,'YTick',[0:5:1000]); %设置y轴坐标显示范围，间隔为5
set(gca,'XTick',[1:1:1000]) %设置x轴坐标显示范围，间隔为1

legend( '实际观看序列','候选频道TOP1','候选频道TOP2','候选频道TOP3','候选频道TOP4','候选频道TOP5');%设置图例

handles.SingleUserResult = SingleUserResult;
guidata(hObject,handles);%保存
set(handles.popup_TopN,'Enable','on');

%设置候选频道数量TopN并显示对应结果
function popup_TopN_Callback(hObject, eventdata, handles)
%获取数据
SingleUserResult = handles.SingleUserResult;
%批量隐藏
set(SingleUserResult.SingleDayResult.recommchannelLine(:),'Visible','off');
%读取需要观察的TopN
TopNlist = get(handles.popup_TopN,'String');
TopNindex = get(handles.popup_TopN,'Value');
SingleUserResult.SingleDayResult.TopN= str2num(TopNlist{TopNindex});
%显示数据结果
set(handles.edit_TotalChanNum,'String',num2str(SingleUserResult.SingleDayResult.TotalChanNum));
set(handles.edit_RecommChanNum,'String',num2str(SingleUserResult.SingleDayResult.RecommChanNum));
set(handles.edit_AcceptedChanNum,'String',num2str(SingleUserResult.SingleDayResult.AcceptedChanNum(SingleUserResult.SingleDayResult.TopN)));
set(handles.edit_recall,'String',num2str(SingleUserResult.SingleDayResult.recall(SingleUserResult.SingleDayResult.TopN)));
set(handles.edit_acc,'String',num2str(SingleUserResult.SingleDayResult.acc(SingleUserResult.SingleDayResult.TopN)));
%显示所需部分曲线
for i = 1:SingleUserResult.SingleDayResult.TopN
    set(SingleUserResult.SingleDayResult.recommchannelLine(i),'Visible','on');
end

%观察第resultDay天，默认为第windows+1(~,31)天
function edit_ResultDay_Callback(hObject, eventdata, handles)
temp = str2double(get(hObject,'String'));
if (isempty(temp)||temp<handles.myGUIdata.windows+1)
    set(hObject,'String',num2str(handles.myGUIdata.windows+1));
end
if (temp>31)
    set(hObject,'String',num2str(31));
end 


%%%%%%%%%%%%%%%%%%%%%%%%%各控件的创建函数%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%---------------------神经网络选取及各种参数输入---------------------------

function edit_inputDir_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_outputDir_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_UserIDBegin_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_UserIDEnd_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_windows_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function popup_network_name_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_seqlength_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_n_epoch_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_batch_size_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------显示（输出）该用户该月的平均推荐正确率的统计结果-------------
function edit_ResultUserID_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-------------显示该用户该天的推荐预测与实际观看对比结果-------------------
function edit_ResultDay_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function popup_TopN_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_TotalChanNum_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_RecommChanNum_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_AcceptedChanNum_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_recall_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_acc_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%▲综上%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
