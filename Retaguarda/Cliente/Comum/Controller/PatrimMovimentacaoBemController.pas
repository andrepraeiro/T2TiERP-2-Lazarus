{*******************************************************************************
Title: T2Ti ERP                                                                 
Description: Controller do lado Cliente relacionado � tabela [PATRIM_MOVIMENTACAO_BEM] 
                                                                                
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
unit PatrimMovimentacaoBemController;

{$MODE Delphi}

interface

uses
  Classes, Dialogs, SysUtils, DB, LCLIntf, LCLType, LMessages, Forms, Controller,
  VO, ZDataset, PatrimMovimentacaoBemVO;

type
  TPatrimMovimentacaoBemController = class(TController)
  private
  public
    class function Consulta(pFiltro: String; pPagina: String): TZQuery;
    class function ConsultaLista(pFiltro: String): TListaPatrimMovimentacaoBemVO;
    class function ConsultaObjeto(pFiltro: String): TPatrimMovimentacaoBemVO;

    class procedure Insere(pObjeto: TPatrimMovimentacaoBemVO);
    class function Altera(pObjeto: TPatrimMovimentacaoBemVO): Boolean;

    class function Exclui(pId: Integer): Boolean;

  end;

implementation

uses UDataModule, T2TiORM;

var
  ObjetoLocal: TPatrimMovimentacaoBemVO;

class function TPatrimMovimentacaoBemController.Consulta(pFiltro: String; pPagina: String): TZQuery;
begin
  try
    ObjetoLocal := TPatrimMovimentacaoBemVO.Create;
    Result := TT2TiORM.Consultar(ObjetoLocal, pFiltro, pPagina);
  finally
    ObjetoLocal.Free;
  end;
end;

class function TPatrimMovimentacaoBemController.ConsultaLista(pFiltro: String): TListaPatrimMovimentacaoBemVO;
begin
  try
    ObjetoLocal := TPatrimMovimentacaoBemVO.Create;
    Result := TListaPatrimMovimentacaoBemVO(TT2TiORM.Consultar(ObjetoLocal, pFiltro, True));
  finally
    ObjetoLocal.Free;
  end;
end;

class function TPatrimMovimentacaoBemController.ConsultaObjeto(pFiltro: String): TPatrimMovimentacaoBemVO;
begin
  try
    Result := TPatrimMovimentacaoBemVO.Create;
    Result := TPatrimMovimentacaoBemVO(TT2TiORM.ConsultarUmObjeto(Result, pFiltro, True));
  finally
  end;
end;

class procedure TPatrimMovimentacaoBemController.Insere(pObjeto: TPatrimMovimentacaoBemVO);
var
  UltimoID: Integer;
begin
  try
    UltimoID := TT2TiORM.Inserir(pObjeto);
    Consulta('ID = ' + IntToStr(UltimoID), '0');
  finally
  end;
end;

class function TPatrimMovimentacaoBemController.Altera(pObjeto: TPatrimMovimentacaoBemVO): Boolean;
begin
  try
    Result := TT2TiORM.Alterar(pObjeto);
  finally
  end;
end;

class function TPatrimMovimentacaoBemController.Exclui(pId: Integer): Boolean;
var
  ObjetoLocal: TPatrimMovimentacaoBemVO;
begin
  try
    ObjetoLocal := TPatrimMovimentacaoBemVO.Create;
    ObjetoLocal.Id := pId;
    Result := TT2TiORM.Excluir(ObjetoLocal);
  finally
    FreeAndNil(ObjetoLocal)
  end;
end;

initialization
  Classes.RegisterClass(TPatrimMovimentacaoBemController);

finalization
  Classes.UnRegisterClass(TPatrimMovimentacaoBemController);

end.

