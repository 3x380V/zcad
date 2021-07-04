{
*****************************************************************************
*                                                                           *
*  This file is part of the ZCAD                                            *
*                                                                           *
*  See the file COPYING.modifiedLGPL.txt, included in this distribution,    *
*  for details about the copyright.                                         *
*                                                                           *
*  This program is distributed in the hope that it will be useful,          *
*  but WITHOUT ANY WARRANTY; without even the implied warranty of           *
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                     *
*                                                                           *
*****************************************************************************
}
{
@author(Andrey Zubarev <zamtmn@yandex.ru>) 
}
{$MODE DELPHI}
unit uzccommand_dataimport;
{$INCLUDE def.inc}

interface
uses
  LazLogger,SysUtils,LazUTF8,
  gzctnrvectortypes,uzelongprocesssupport,
  uzeentity,
  uzccommandsabstract,uzccommandsimpl,
  uzcdialogsfiles,
  uzbtypesbase,uzbpaths,uzcutils,uzcinterface,
  uzeentitiestypefilter,
  uzcdrawings,uzedrawingsimple,uzgldrawcontext,
  gzctnrvectorpobjects,varmandef,uzcenitiesvariablesextender,
  CsvDocument;

implementation

procedure FilterArray(source,dest:PGDBOpenArrayOfPObjects;prop,value:string);
var
   pvisible:PGDBObjEntity;
   ir:itrec;
   pvd:pvardesk;
   pentvarext:PTVariablesExtender;
begin
  pvisible:=source.beginiterate(ir);
  if pvisible<>nil then
  repeat
    pentvarext:=pvisible^.GetExtension(typeof(TVariablesExtender));
    pvd:=pentvarext^.entityunit.FindVariable(prop);
    if pvd<>nil then begin
      if pvd.data.PTD.GetValueAsString(pvd.data.Instance)=value then
        dest.PushBackData(pvisible);
    end;
  pvisible:=source.iterate(ir);
  until pvisible=nil;
end;

procedure SetArray(source:PGDBOpenArrayOfPObjects;prop,value:string;var drawing:TSimpleDrawing;var DC:TDrawContext);
var
  pvisible:PGDBObjEntity;
  ir:itrec;
  pvd:pvardesk;
  pentvarext:PTVariablesExtender;
begin
  pvisible:=source.beginiterate(ir);
  if pvisible<>nil then
  repeat
    pentvarext:=pvisible^.GetExtension(typeof(TVariablesExtender));
    pvd:=pentvarext^.entityunit.FindVariable(prop);
    if pvd<>nil then begin
      pvd.data.PTD.SetValueFromString(pvd.data.Instance,value);
      pvisible.FormatEntity(drawing,DC);
    end;
  pvisible:=source.iterate(ir);
  until pvisible=nil;
end;

function GetFactColCount(FDoc:TCSVDocument;ARow: Integer):Integer;
begin
  Result:=FDoc.ColCount[ARow];
  while (result>0)and(FDoc.Cells[result-1,ARow]='')do
   dec(result);
end;

procedure ProcessCSVLine(FDoc:TCSVDocument;Row:Integer;var drawing:TSimpleDrawing;var DC:TDrawContext);
var
  Filter:TEntsTypeFilter;
  entarray,filtredentarray:TZctnrVectorPGDBaseObjects;
  fltcounter,fltcount,FactColCount:integer;
  a1,a2,atemp:PGDBOpenArrayOfPObjects;
begin
  FactColCount:=GetFactColCount(FDoc,row);
  if (FactColCount mod 2)=0 then
    inc(FactColCount);
  if (FactColCount<3){or((FactColCount mod 2)<>1)} then begin
    ZCMsgCallBackInterface.TextMessage(format('In row %d wrong number of parameters',[row+1]),TMWOHistoryOut);
    exit;
  end;
  Filter:=TEntsTypeFilter.Create;
  Filter.AddTypeName(FDoc.Cells[0,Row]);
  Filter.SetFilter;
  if Filter.IsEmpty then begin
    ZCMsgCallBackInterface.TextMessage(format('In row %d not found entity type %s',[row+1,FDoc.Cells[0,Row]]),TMWOHistoryOut);
    Filter.Destroy;
    exit;
  end;
  entarray.init(100);
  drawings.FindMultiEntityByType(Filter,entarray);
  if entarray.Count=0 then begin
    ZCMsgCallBackInterface.TextMessage(format('In row %d entity type %s not found in drawing',[row+1,FDoc.Cells[0,Row]]),TMWOHistoryOut);
    Filter.Destroy;
    entarray.Clear;
    entarray.done;
    exit;
  end;

  filtredentarray.init(100);

  a1:=@entarray;
  a2:=@filtredentarray;

  fltcounter:=1;
  fltcount:=(FactColCount-1) div 2;
  while fltcount>fltcounter do begin
    FilterArray(a1,a2,FDoc.Cells[fltcounter*2-1,Row],FDoc.Cells[fltcounter*2,Row]);
    a1.Clear;
    atemp:=a2;
    a2:=a1;
    a1:=atemp;
    inc(fltcounter);
  end;

  if a1^.Count<>1 then
    ZCMsgCallBackInterface.TextMessage(format('In row %d found %d candidats',[row+1,a1^.Count]),TMWOHistoryOut);
  if a1^.Count<>0 then
    SetArray(a1,FDoc.Cells[fltcounter*2-1,Row],FDoc.Cells[fltcounter*2,Row],drawing,DC);

  Filter.Destroy;
  entarray.Clear;
  entarray.done;
  filtredentarray.Clear;
  filtredentarray.done;
end;

function DataImport_com(operands:TCommandOperands):TCommandResult;
var
  pv:pGDBObjEntity;
  ir:itrec;
  lph:TLPSHandle;
  isload:boolean;
  FDoc:TCSVDocument;
  FileName:AnsiString;
  Row:Integer;
  drawing:PTSimpleDrawing;
  DC:TDrawContext;
begin
  if length(operands)=0 then begin
    isload:=OpenFileDialog(FileName,1,'csv',CSVFileFilter,'','Open something...');
    if not isload then
      exit(cmd_cancel);
  end else begin
    FileName:=ExpandPath(operands);
    FileName:=FindInSupportPath(SupportPath,operands);
  end;
  isload:=FileExists(utf8tosys(FileName));
  if isload then begin
    drawing:=drawings.GetCurrentDWG;
    DC:=drawing.CreateDrawingRC;
    FDoc:=TCSVDocument.Create;
    try
      FDoc.Delimiter:=';';
      FDoc.LoadFromFile(utf8tosys(FileName));
      lph:=lps.StartLongProcess('Data import',nil,FDoc.RowCount);
      for Row:=0 to FDoc.RowCount-1 do begin
        ProcessCSVLine(FDoc,Row,drawing^,DC);
        lps.ProgressLongProcess(lph,Row);
      end;
      lps.EndLongProcess(lph);
    finally
      FDoc.Free;
    end;
  end;
end;

initialization
  debugln('{I}[UnitsInitialization] Unit "',{$INCLUDE %FILE%},'" initialization');
  CreateCommandFastObjectPlugin(@DataImport_com,'DataImport',  CADWG,0);
finalization
  debugln('{I}[UnitsFinalization] Unit "',{$INCLUDE %FILE%},'" finalization');
end.