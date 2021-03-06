{*******************************************************************************
Title: T2Ti ERP                                                                 
Description:  VO  relacionado � tabela [REGISTRO_CARTORIO] 
                                                                                
The MIT License                                                                 
                                                                                
Copyright: Copyright (C) 2016 T2Ti.COM                                          
                                                                                
Permission is hereby granted, free of charge, to any person                     
obtaining a copy of this software and associated documentation                  
files (the "Software"), to deal in the Software without                         
restriction, including without limitation the rights to use,                    
copy, modify, merge, publish, distribute, sublicense, and/or sell               
copies of the Software, and to permit persons to whom the                       
Software is furnished to do so, subject to the following                        
conditions:                                                                     
                                                                                
The above copyright notice and this permission notice shall be                  
included in all copies or substantial portions of the Software.                 
                                                                                
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,                 
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES                 
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND                        
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT                     
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,                    
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING                    
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR                   
OTHER DEALINGS IN THE SOFTWARE.                                                 
                                                                                
       The author may be contacted at:                                          
           t2ti.com@gmail.com                                                   
                                                                                
@author Albert Eije (t2ti.com@gmail.com)                    
@version 2.0                                                                    
*******************************************************************************}
unit RegistroCartorioVO;

{$mode objfpc}{$H+}

interface

uses
  VO, Classes, SysUtils, FGL;

type
  TRegistroCartorioVO = class(TVO)
  private
    FID: Integer;
    FID_EMPRESA: Integer;
    FNOME_CARTORIO: String;
    FDATA_REGISTRO: TDateTime;
    FNUMERO: Integer;
    FFOLHA: Integer;
    FLIVRO: Integer;
    FNIRE: String;

    //Transientes



  published 
    property Id: Integer  read FID write FID;
    property IdEmpresa: Integer  read FID_EMPRESA write FID_EMPRESA;
    property NomeCartorio: String  read FNOME_CARTORIO write FNOME_CARTORIO;
    property DataRegistro: TDateTime  read FDATA_REGISTRO write FDATA_REGISTRO;
    property Numero: Integer  read FNUMERO write FNUMERO;
    property Folha: Integer  read FFOLHA write FFOLHA;
    property Livro: Integer  read FLIVRO write FLIVRO;
    property Nire: String  read FNIRE write FNIRE;


    //Transientes



  end;

  TListaRegistroCartorioVO = specialize TFPGObjectList<TRegistroCartorioVO>;

implementation


initialization
  Classes.RegisterClass(TRegistroCartorioVO);

finalization
  Classes.UnRegisterClass(TRegistroCartorioVO);

end.
