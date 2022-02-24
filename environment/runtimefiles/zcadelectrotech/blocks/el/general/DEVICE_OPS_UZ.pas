unit DEVICE_OPS_UZ;
interface
uses system,devices;
usescopy objname;
usescopy blocktype;
var
   Device_Type:TDeviceType;(*'Тип устройства'*) 

   DB_link:GDBString;(*'Материал'*)
   
   GC_HeadDevice:GDBString;
   GC_HDShortName:GDBString;
   GC_HDGroup:Integer;
   GC_NumberInGroup:Integer;

   SerialConnection:Integer;


   EL_Cab_AddLength:GDBDouble;(*'Добавлять к длине кабеля'*)
implementation
begin
   DB_link:='С2000-ПИ';

   BTY_TreeCoord:='PLAN_OPS_Преобразователь интерфейсов';
   Device_Type:=TDT_PriborOPS;
   NMO_Template:='@@[NMO_BaseName]@@[NMO_Prefix]@@[NMO_Suffix]';
   EL_Cab_AddLength:=1;

   NMO_Prefix:='';
   NMO_BaseName:='UZ';
   NMO_Suffix:='??';



   SerialConnection:=1;
   GC_HDShortName:='??';
   GC_HeadDevice:='??';
   GC_HDGroup:=0;
end.