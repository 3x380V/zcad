unit OPS_shleif;
interface
uses System,cables;
var
  SUMMARY_StyleName:GDBString;(*'�����'*)
  NC_StyleDef:GDBBoolean;(*'����� ����������� �����'*)
  NMO_Name:GDBString;(*'�����������'*)
  NMO_BaseName:GDBString;(*'�������� ���'*)
  NMO_Prefix:GDBString;(*'�������'*)
  NMO_PrefixTemplate:GDBString;(*'������ ��������'*)
  NMO_Suffix:GDBString;(*'�������'*)
  NMO_SuffixTemplate:GDBString;(*'������ ��������'*)
  NMO_Template:GDBString;(*'������ �����������'*)
  GC_HeadDevice:GDBString;(*'��������� ����������'*)
  GC_HeadDeviceTemplate:GDBString;(*'������ ��������� ����������'*)
  GC_HDShortName:GDBString;(*'�������� ��� ��������� ����������'*)
  GC_HDShortNameTemplate:GDBString;(*'������ ��������� ����� ��������� ����������'*)
  GC_HDGroup:GDBString;(*'������ � �������� ����������'*)
  GC_HDGroupTemplate:GDBString;(*'������ ������'*)
  SerialConnection:Integer;
  GC_NumberInGroup:Integer;(*'����� ���������� � ������'*)
  GC_Metric:GDBString;
  DB_link:GDBString;(*'��������'*)
  LENGTH_RoundTo:Integer;(*'��������� ��'*)
  LENGTH_Add:GDBDouble;(*'�������� � �����'*)
  LENGTH_Scale:GDBDouble;(*'�������'*)
  CABLE_Type:TCableType;(*'���'*)
  CABLE_Segment:Integer;(*'�������'*)
  CABLE_WireCount:Integer;(*'����� ���'*)
  CABLE_TotalCD:Integer;(*'���������� ���������'*)
  AmountD:GDBDouble;(*'�����'*)
implementation
begin
  SUMMARY_StyleName:='���_�������� �����';
  NC_StyleDef:=true;
  NMO_Name:='';
  NMO_BaseName:='�';
  NMO_Prefix:='';
  NMO_PrefixTemplate:='@@[GC_NumberInGroup]';
  NMO_Suffix:='1';
  NMO_SuffixTemplate:='';
  NMO_Template:='@@[NMO_Prefix]@@[NMO_BaseName]@@[NMO_Suffix]';
  GC_HeadDevice:='5';
  GC_HeadDeviceTemplate:='@@[NMO_Prefix]';
  GC_HDShortName:='5';
  GC_HDShortNameTemplate:='@@[NMO_Prefix]';
  GC_HDGroup:='1';
  GC_HDGroupTemplate:='';
  SerialConnection:=1;
  GC_NumberInGroup:=1;
  GC_Metric:='�����';
  DB_link:='';
  LENGTH_RoundTo:=0;
  LENGTH_Add:=4.0;
  LENGTH_Scale:=0.1;
  CABLE_Type:=TCT_ShleifOPS;
  CABLE_Segment:=0;
  CABLE_WireCount:=0;
  CABLE_TotalCD:=9;
  AmountD:=0.0;
end.