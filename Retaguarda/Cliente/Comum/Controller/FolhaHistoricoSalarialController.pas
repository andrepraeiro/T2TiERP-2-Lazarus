{*******************************************************************************
Title: T2Ti ERP                                                                 
Description: Controller do lado Cliente relacionado � tabela [FOLHA_HISTORICO_SALARIAL] 
                                                                                
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
unit FolhaHistoricoSalarialController;

{$MODE Delphi}

interface

uses
  Classes, Dialogs, SysUtils, DB, LCLIntf, LCLType, LMessages, Forms, Controller,
  VO, ZDataset, FolhaHistoricoSalarialVO;

type
  TFolhaHistoricoSalarialController = class(TController)
  private
  public
    class function Consulta(pFiltro: String; pPagina: String): TZQuery;
    class function ConsultaLista(pFiltro: String): TListaFolhaHistoricoSalarialVO;
    class function ConsultaObjeto(pFiltro: String): TFolhaHistoricoSalarialVO;

    class procedure Insere(pObjeto: TFolhaHistoricoSalarialVO);
    class function Altera(pObjeto: TFolhaHistoricoSalarialVO): Boolean;

    class function Exclui(pId: Integer): Boolean;

  end;

implementation

uses UDataModule, T2TiORM;

var
  ObjetoLocal: TFolhaHistoricoSalarialVO;

class function TFolhaHistoricoSalarialController.Consulta(pFiltro: String; pPagina: String): TZQuery;
begin
  try
    ObjetoLocal := TFolhaHistoricoSalarialVO.Create;
    Result := TT2TiORM.Consultar(ObjetoLocal, pFiltro, pPagina);
  finally
    ObjetoLocal.Free;
  end;
end;

class function TFolhaHistoricoSalarialController.ConsultaLista(pFiltro: String): TListaFolhaHistoricoSalarialVO;
begin
  try
    ObjetoLocal := TFolhaHistoricoSalarialVO.Create;
    Result := TListaFolhaHistoricoSalarialVO(TT2TiORM.Consultar(ObjetoLocal, pFiltro, True));
  finally
    ObjetoLocal.Free;
  end;
end;

class function TFolhaHistoricoSalarialController.ConsultaObjeto(pFiltro: String): TFolhaHistoricoSalarialVO;
begin
  try
    Result := TFolhaHistoricoSalarialVO.Create;
    Result := TFolhaHistoricoSalarialVO(TT2TiORM.ConsultarUmObjeto(Result, pFiltro, True));
  finally
  end;
end;

class procedure TFolhaHistoricoSalarialController.Insere(pObjeto: TFolhaHistoricoSalarialVO);
var
  UltimoID: Integer;
begin
  try
    UltimoID := TT2TiORM.Inserir(pObjeto);
    Consulta('ID = ' + IntToStr(UltimoID), '0');
  finally
  end;
end;

class function TFolhaHistoricoSalarialController.Altera(pObjeto: TFolhaHistoricoSalarialVO): Boolean;
begin
  try
    Result := TT2TiORM.Alterar(pObjeto);
  finally
  end;
end;

class function TFolhaHistoricoSalarialController.Exclui(pId: Integer): Boolean;
var
  ObjetoLocal: TFolhaHistoricoSalarialVO;
begin
  try
    ObjetoLocal := TFolhaHistoricoSalarialVO.Create;
    ObjetoLocal.Id := pId;
    Result := TT2TiORM.Excluir(ObjetoLocal);
  finally
    FreeAndNil(ObjetoLocal)
  end;
end;

initialization
  Classes.RegisterClass(TFolhaHistoricoSalarialController);

finalization
  Classes.UnRegisterClass(TFolhaHistoricoSalarialController);

end.

