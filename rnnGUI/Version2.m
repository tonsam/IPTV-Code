%%%%%%%%%%%%%%%%%%%%%%%%%%���������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function varargout = Version2(varargin)
%VERSION1 MATLAB code file for Version1.fig
% Last Modified by GUIDE v2.5 03-May-2018 18:24:19
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Version2_OpeningFcn, ...
                   'gui_OutputFcn',  @Version2_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end
if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:}); %������
else
    gui_mainfcn(gui_State, varargin{:});
end

% End initialization code - DO NOT EDIT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%���ڳ�ʼ��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Version2_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for Version1
handles.output = hObject;

%���� Tab Group
handles.tgroup = uitabgroup('Parent', handles.figure1,'Position', [0.005 0.005 0.995 0.995]); 
%���� Tab group ��λ��
handles.tab1 = uitab('Parent', handles.tgroup, 'Title', ' 1.DataInputAndRun ');
handles.tab2 = uitab('Parent', handles.tgroup, 'Title', ' 2.AllResult ');
handles.tab3 = uitab('Parent', handles.tgroup, 'Title', ' 3.SingleUserResult ');
handles.tab4 = uitab('Parent', handles.tgroup, 'Title', ' 4.SingleDayResult ');
%��ÿ��Panel ��Ӧ�� ÿ��Tab ҳ��
set(handles.DataInputAndRunPanel,'Parent',handles.tab1)
set(handles.AllResultPanel,'Parent',handles.tab2)
set(handles.SingleUserResultPanel,'Parent',handles.tab3)
set(handles.SingleDayResultPanel,'Parent',handles.tab4)
%��DataInputAndRunPanel��λ����������Panelλ����DataInputAndRunPanel��ͬ
set(handles.AllResultPanel,'position',get(handles.DataInputAndRunPanel,'position'));
set(handles.SingleUserResultPanel,'position',get(handles.DataInputAndRunPanel,'position'));
set(handles.SingleDayResultPanel,'position',get(handles.DataInputAndRunPanel,'position'));

% Update handles structure
guidata(hObject, handles);
% UIWAIT makes Version1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function varargout = Version2_OutputFcn(hObject, eventdata, handles)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%�����ؼ��Ļص�����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%----------Tab1: 1.DataInputAndRun ������ѡȡ�����ֲ�������-------------%
%ѵ���������
function RUN_button_Callback(hObject, eventdata, handles)
%��ȡ��������
myGUIdata.inputDir = get(handles.edit_inputDir,'String');
myGUIdata.outputDir = get(handles.edit_outputDir,'String');
myGUIdata.UserIDBegin = str2double(get(handles.edit_UserIDBegin,'String'));
myGUIdata.UserIDEnd = str2double(get(handles.edit_UserIDEnd,'String'));
myGUIdata.windows = str2double(get(handles.edit_windows,'String'));
channeltypelist = get(handles.popup_channeltype,'String');
channeltypeindex = get(handles.popup_channeltype,'Value');
myGUIdata.channeltype = str2double(channeltypelist{channeltypeindex}(1));
myGUIdata.channelFreqPercent = str2double(get(handles.edit_channelFreqPercent,'String'));
myGUIdata.seqlength = str2double(get(handles.edit_seqlength,'String'));
netlist = get(handles.popup_network_name,'String');
netindex = get(handles.popup_network_name,'Value');
myGUIdata.network_name = netlist{netindex};
myGUIdata.n_epoch = str2double(get(handles.edit_n_epoch,'String'));
myGUIdata.batch_size = str2double(get(handles.edit_batch_size,'String'));
myGUIdata.n_hidden_nodes = str2double(get(handles.edit_n_hidden_nodes,'String'));
%ѵ���������
myGUIdata.outputFile = enterRnn(myGUIdata);
disp(myGUIdata);
%���������̨����
if ~isfield(handles,'consoleInfo')   
    handles.consoleInfo ={ '����������Ϣ��'};
end
tstr = ['   ',datestr(now),'  ѵ������:',num2str(myGUIdata.UserIDBegin),'-',num2str(myGUIdata.UserIDEnd),';�Ѽ�������ļ�����:',myGUIdata.outputFile]; 
handles.consoleInfo = [handles.consoleInfo,tstr];
set(handles.text_ConsoleInfo,'String',handles.consoleInfo);
set(handles.edit_outputFile,'String',myGUIdata.outputFile);
%������ؼ�����
set(handles.ShowUserResult_button,'Enable','On');
set(handles.ShowDayResult_button,'Enable','off');

handles.myGUIdata = myGUIdata;
guidata(hObject,handles);
%���ؽ���ļ�����
function button_loadResult_Callback(hObject, eventdata, handles)
temp = get(handles.edit_outputFile,'String');
load(temp);
handles.myGUIdata = myGUIdata;
%���������̨����
if ~isfield(handles,'consoleInfo')   
    handles.consoleInfo ={ '����������Ϣ��'};
end
tstr = ['   ',datestr(now),'  �Ѽ���ָ���ļ�����',num2str(myGUIdata.UserIDBegin),'-',num2str(myGUIdata.UserIDEnd),';',myGUIdata.outputFile]; 
handles.consoleInfo = [handles.consoleInfo,tstr];
set(handles.text_ConsoleInfo,'String',handles.consoleInfo);

guidata(hObject,handles);

%inputDirĬ��ֵ����C:\Work\IPTV\IPTV Recommendation\dataset\
function edit_inputDir_Callback(hObject, eventdata, handles)
inputDir =get(hObject,'String');
if (isempty(inputDir))
    set(hObject,'String','C:\Work\IPTV\IPTV Recommendation\dataset\');
end 
%OnputDirĬ��ֵ����C:\Work\IPTV\IPTV Recommendation\Result\
function edit_outputDir_Callback(hObject, eventdata, handles)
outputDir =get(hObject,'String');
if (isempty(outputDir))
    set(hObject,'String','C:\Work\IPTV\IPTV Recommendation\Result\');
end   
%OnputFileĬ��ֵ����C:\Work\IPTV\IPTV Recommendation\Result\Trainingset3000WithDuration[10-3600]tempGUI.mat
function edit_outputFile_Callback(hObject, eventdata, handles)
temp=get(hObject,'String');
if (isempty(temp))
    set(hObject,'String','C:\Work\IPTV\IPTV Recommendation\Result\Trainingset3000WithDuration[10-3600]tempGUI.mat');
end   
%UserIDBegin��ʼ�û����1
function edit_UserIDBegin_Callback(hObject, eventdata, handles)
UserIDBegin = str2double(get(hObject,'String'));
UserIDEnd = str2double(get(handles.edit_UserIDEnd,'String'));
if (isnan(UserIDBegin) || UserIDBegin<1)
    set(hObject,'String','1');
end   
if (UserIDBegin>UserIDEnd)
    set(hObject,'String',num2str(UserIDEnd));
end
%UserIDEnd�����û����3000
function edit_UserIDEnd_Callback(hObject, eventdata, handles)
UserIDEnd = str2double(get(hObject,'String'));
UserIDBegin = str2double(get(handles.edit_UserIDBegin,'String'));
if (isnan(UserIDEnd) || UserIDEnd>3000)
    set(hObject,'String','3000');
end 
if (UserIDBegin>UserIDEnd)
    set(hObject,'String',num2str(UserIDBegin));
end
%windowsѵ�����ڳ���7
function edit_windows_Callback(hObject, eventdata, handles)
temp = get(hObject,'String');
if (isempty(temp))
    set(hObject,'String','7');
end 
%channeltypeƵ��ɸѡ����0-���(����channelFreqPercent) 1��2��
function popup_channeltype_Callback(hObject, eventdata, handles)
channeltypelist = get(handles.popup_channeltype,'String');
channeltypeindex = get(handles.popup_channeltype,'Value');
channeltype = channeltypelist{channeltypeindex};
% disp(channeltype(1));
if strcmp(channeltype,'0-���Ƶ��')
    set(handles.edit_channelFreqPercent,'Enable','off');
else
    set(handles.edit_channelFreqPercent,'Enable','on');
end
%channeltypeƵ������Ƶ�ʵ�4(0~100)
function edit_channelFreqPercent_Callback(hObject, eventdata, handles)
temp = str2double(get(hObject,'String'));
if (isempty(temp))
    set(hObject,'String','4');
end 
%seqlength���г���5
function edit_seqlength_Callback(hObject, eventdata, handles)
temp = get(hObject,'String');
if (isempty(temp))
    set(hObject,'String','5');
end 
%network_name��������lstm
function popup_network_name_Callback(hObject, eventdata, handles)
%n_epochѵ������ 7
function edit_n_epoch_Callback(hObject, eventdata, handles)
temp = get(hObject,'String');
if (isempty(temp))
    set(hObject,'String','7');
end 
%ѵ��ʱbatch_size��С5
function edit_batch_size_Callback(hObject, eventdata, handles)
temp = get(hObject,'String');
if (isempty(temp))
    set(hObject,'String','5');
end 
%ѵ��ʱn_hidden_nodes��С30
function edit_n_hidden_nodes_Callback(hObject, eventdata, handles)
temp =get(hObject,'String');
if (isempty(temp))
    set(hObject,'String','30');
end 
%-----------------Tab2: 2.AllResult �����û������ͳ�ƽ��----------------%
function ShowAllResult_button_Callback(hObject, eventdata, handles)

%------------Tab3:3.SingleUserResult ���û����µ����ͳ�ƽ��-------------%
function ShowUserResult_button_Callback(hObject, eventdata, handles)
%���в�����ʾͼ����axes1�ؼ���
axes(handles.axes1);
%ԭʼUserIDӳ�䵽������ݼ����newUserID
SingleUserResult.ResultUserID = str2double(get(handles.edit_ResultUserID,'String'));
SingleUserResult.newResultUserID = SingleUserResult.ResultUserID - handles.myGUIdata.UserIDBegin+1;
%��������
load(handles.myGUIdata.outputFile);
SingleUserResult.recomm5 = someOutput.recomm{1,SingleUserResult.newResultUserID};
%ȥ��404����
for i = 1:size(SingleUserResult.recomm5,1)
    for j = 1:size(SingleUserResult.recomm5,2)
        if SingleUserResult.recomm5(i,j) ==404 
            SingleUserResult.recomm5(i,j) =NaN;
        end
    end
end
SingleUserResult.recomm5 = SingleUserResult.recomm5';

%��ͼ��������
plot(SingleUserResult.recomm5,'-p','DisplayName','recomm5');
title(['���Ϊ',num2str(SingleUserResult.ResultUserID),'�Ƽ�׼ȷ�ʽ������ͼ'])%����ͼ�����
xlabel('��x����Լ�') %����x�����
ylabel('�Ƽ�׼ȷ��') %����y�����
legend('TOP1','TOP2','TOP3','TOP4','TOP5');%����ͼ��
set(gca,'YTick',[0:0.1:1]); %����y��������ʾ��Χ�����Ϊ0.1
set(gca,'XTick',[1:1:31]) %����x��������ʾ��Χ�����Ϊ1
%���ú�������ʾ����
xticklabel = {};
for i = handles.myGUIdata.windows+1: 32
    xticklabel = [xticklabel,{num2str(i)}];
end
set(gca,'XTickLabel',xticklabel); 

%�����һ���ۿ����������Ա����
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

function edit_ValidDayNum_Callback(hObject, eventdata, handles)
function edit_UserTotalChanNum_Callback(hObject, eventdata, handles)
function edit_UserAcceptedChanNum_Callback(hObject, eventdata, handles)
function edit_UserRecommChanNum_Callback(hObject, eventdata, handles)

%----Tab4:4.SingleDayResult ���û�������Ƽ�Ԥ����ʵ�ʹۿ��Ա�TOPn���----%
function ShowDayResult_button_Callback(hObject, eventdata, handles)
%��ʼ��--���
set(handles.edit_TotalChanNum,'String','');
set(handles.edit_RecommChanNum,'String','');
set(handles.edit_AcceptedChanNum,'String','');
set(handles.edit_recall,'String','');
set(handles.edit_acc,'String','');
%���в�����ʾͼ����axes2�ؼ���
axes(handles.axes2);cla;
set(handles.popup_TopN,'Enable','inactive');

%ԭʼUserIDӳ�䵽������ݼ����newUserID
SingleUserResult.ResultUserID = str2double(get(handles.edit_ResultUserID,'String'));
SingleUserResult.newResultUserID = SingleUserResult.ResultUserID - handles.myGUIdata.UserIDBegin+1;
%ԭʼDayIDӳ�䵽������ݼ����newDayID
SingleUserResult.ResultDayID = str2double(get(handles.edit_ResultDay,'String'));
SingleUserResult.newResultDayID = SingleUserResult.ResultDayID - handles.myGUIdata.windows;
%��������
disp(handles.myGUIdata.outputFile);
load(handles.myGUIdata.outputFile);
recommchannel = someOutput.recommchannel{SingleUserResult.newResultUserID,SingleUserResult.newResultDayID};
%����Ƿ��н��
if isempty(recommchannel)
    h=errordlg('���󣺸������������㣬δ����Ԥ�⣬�޽����','����');  
    hu=findall(allchild(h),'style','pushbutton');  
    set(hu,'string','ȷ��')
    return
end
datasetorder = someOutput.datasetorder{SingleUserResult.newResultUserID,SingleUserResult.newResultDayID};
watchorder = someOutput.watchorder{SingleUserResult.newResultUserID,SingleUserResult.newResultDayID};
prediction = someOutput.prediction{SingleUserResult.newResultUserID,SingleUserResult.newResultDayID};
%��ȡ����ĸ��ֽ��
SingleUserResult.SingleDayResult = getSDR(recommchannel,watchorder,datasetorder,prediction,handles.myGUIdata.seqlength);

%��ͼ��������
SingleUserResult.SingleDayResult.datasetorderLine = plot(SingleUserResult.SingleDayResult.datasetorder ,'--ok');
hold on;
SingleUserResult.SingleDayResult.recommchannelLine = plot(SingleUserResult.SingleDayResult.recommchannel ,'-x');
title(['�û�',num2str(SingleUserResult.ResultUserID),'�ڵ�',num2str(SingleUserResult.ResultDayID ),'��ʵ�ʹۿ���Ԥ���Ƽ���Ƶ�����жԱ�����ͼ'])%����ͼ�����
xlabel('��x���ۿ�Ƶ��') %����x�����
ylabel('Ƶ����') %����y�����
set(gca,'YTick',[0:5:1000]); %����y��������ʾ��Χ�����Ϊ5
set(gca,'XTick',[1:1:1000]) %����x��������ʾ��Χ�����Ϊ1

legend( 'ʵ�ʹۿ�����','��ѡƵ��TOP1','��ѡƵ��TOP2','��ѡƵ��TOP3','��ѡƵ��TOP4','��ѡƵ��TOP5');%����ͼ��

handles.SingleUserResult = SingleUserResult;
guidata(hObject,handles);%����
set(handles.popup_TopN,'Enable','on');

%���ú�ѡƵ������TopN����ʾ��Ӧ���
function popup_TopN_Callback(hObject, eventdata, handles)
%��ȡ����
SingleUserResult = handles.SingleUserResult;
%��������
set(SingleUserResult.SingleDayResult.recommchannelLine(:),'Visible','off');
%��ȡ��Ҫ�۲��TopN
TopNlist = get(handles.popup_TopN,'String');
TopNindex = get(handles.popup_TopN,'Value');
SingleUserResult.SingleDayResult.TopN= str2num(TopNlist{TopNindex});
%��ʾ���ݽ��
set(handles.edit_TotalChanNum,'String',num2str(SingleUserResult.SingleDayResult.TotalChanNum));
set(handles.edit_RecommChanNum,'String',num2str(SingleUserResult.SingleDayResult.RecommChanNum));
set(handles.edit_AcceptedChanNum,'String',num2str(SingleUserResult.SingleDayResult.AcceptedChanNum(SingleUserResult.SingleDayResult.TopN)));
set(handles.edit_recall,'String',num2str(SingleUserResult.SingleDayResult.recall(SingleUserResult.SingleDayResult.TopN)));
set(handles.edit_acc,'String',num2str(SingleUserResult.SingleDayResult.acc(SingleUserResult.SingleDayResult.TopN)));
%��ʾ���貿������
for i = 1:SingleUserResult.SingleDayResult.TopN
    set(SingleUserResult.SingleDayResult.recommchannelLine(i),'Visible','on');
end

%�۲��resultDay�죬Ĭ��Ϊ��windows+1(~,31)��
function edit_ResultDay_Callback(hObject, eventdata, handles)
temp = str2double(get(hObject,'String'));
if (isempty(temp)||temp<handles.myGUIdata.windows+1)
    set(hObject,'String',num2str(handles.myGUIdata.windows+1));
end
if (temp>31)
    set(hObject,'String',num2str(31));
end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%���ؼ��Ĵ�������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%----------Tab1: 1.DataInputAndRun ������ѡȡ�����ֲ�������-------------%
function edit_inputDir_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_outputDir_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_outputFile_CreateFcn(hObject, eventdata, handles)
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
function popup_channeltype_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_channelFreqPercent_CreateFcn(hObject, eventdata, handles)
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
function edit_n_hidden_nodes_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%-----------------Tab2: 2.AllResult �����û������ͳ�ƽ��----------------%

%------------Tab3:3.SingleUserResult ���û����µ����ͳ�ƽ��-------------%
function edit_ResultUserID_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_ValidDayNum_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_UserTotalChanNum_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_UserRecommChanNum_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_UserAcceptedChanNum_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%----Tab4:4.SingleDayResult ���û�������Ƽ�Ԥ����ʵ�ʹۿ��Ա�TOPn���----%
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

