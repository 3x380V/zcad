interface
uses System,cables;
var
  NMO_Name:GDBString;(*'�����������'*)
  NMO_BaseName:GDBString;(*'�������� ���'*)
  NMO_Prefix:GDBString;(*'�������'*)
  NMO_PrefixTemplate:GDBString;(*'������ ��������'*)
  NMO_Suffix:GDBString;(*'�������'*)
  NMO_SuffixTemplate:GDBString;(*'������ ��������'*)
  NMO_Template:GDBString;(*'������ �����������'*)
  DB_link:GDBString;(*'��������'*)
  LENGTH_RoundTo:GDBInteger;(*'��������� ��'*)
  LENGTH_Add:GDBDouble;(*'�������� � �����'*)
  LENGTH_Scale:GDBDouble;(*'�������'*)
  GC_HeadDevice:GDBString;(*'�������� ����������'*)
  GC_HDShortName:GDBString;(*'�������� ��� ��������� ����������'*)
  GC_HDGroup:GDBInteger;(*'������ � �������� ����������'*)
  CABLE_Type:TCableType;(*'���'*)
  CABLE_Segment:GDBInteger;(*'�������'*)
  CABLE_WireCount:GDBInteger;(*'����� ���'*)
  CABLE_TotalCD:GDBInteger;(*'���������� ���������'*)
  AmountD:GDBDouble;(*'�����'*)
implementation
begin
  NMO_Name:='��4-1';
  NMO_BaseName:='@';
  NMO_Prefix:='';
  NMO_PrefixTemplate:='';
  NMO_Suffix:='';
  NMO_SuffixTemplate:='';
  NMO_Template:='@@[NMO_Prefix]@@[GC_HeadDevice]-@@[GC_HDGroup]@@[NMO_Suffix]';
  DB_link:='������ ??';
  LENGTH_RoundTo:=0;
  LENGTH_Add:=4.0;
  LENGTH_Scale:=0.1;
  GC_HeadDevice:='��4';
  GC_HDShortName:='4';
  GC_HDGroup:=1;
  CABLE_Type:=TCT_Control;
  CABLE_Segment:=0;
  CABLE_WireCount:=0;
  CABLE_TotalCD:=3;
  AmountD:=12.0;
end.