{ *******************************************************************************
Title: T2Ti ERP
Description: Janela Hist�ricos para o m�dulo Contabilidade

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
t2ti.com@gmail.com</p>

@author Albert Eije (t2ti.com@gmail.com)
@version 2.0
******************************************************************************* }
unit UContabilHistorico;

{$MODE Delphi}

interface

uses
  BrookHTTPClient, BrookFCLHTTPClientBroker, BrookHTTPUtils, BrookUtils, FPJson, ZDataset,
  LCLIntf, LCLType, LMessages, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, Menus, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids,
  ComCtrls, LabeledCtrls, rxdbgrid, rxtoolbar, DBCtrls, StrUtils,
  Math, Constantes, CheckLst, ActnList, ToolWin, db, BufDataset, Biblioteca,
  ULookup, VO, ContabilHistoricoVO,
  ContabilHistoricoController;

  type

  TFContabilHistorico = class(TFTelaCadastro)
    BevelEdits: TBevel;
    EditDescricao: TLabeledEdit;
    ComboBoxPedeComplemento: TLabeledComboBox;
    MemoHistorico: TLabeledMemo;
    procedure FormCreate(Sender: TObject);
    procedure BotaoConsultarClick(Sender: TObject);
    procedure BotaoSalvarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GridParaEdits; override;

    // Controles CRUD
    function DoInserir: Boolean; override;
    function DoEditar: Boolean; override;
    function DoExcluir: Boolean; override;
    function DoSalvar: Boolean; override;
  end;

var
  FContabilHistorico: TFContabilHistorico;

implementation

{$R *.lfm}

{$REGION 'Controles Infra'}
procedure TFContabilHistorico.BotaoConsultarClick(Sender: TObject);
var
  RetornoConsulta: TZQuery;
  ListaCampos: TStringList;
  i: integer;
begin
  inherited;

  if Sessao.Camadas = 2 then
  begin
    Filtro := MontaFiltro;

    CDSGrid.Close;
    CDSGrid.Open;
    ConfiguraGridFromVO(Grid, ClasseObjetoGridVO);

    ListaCampos  := TStringList.Create;
    RetornoConsulta := TContabilHistoricoController.Consulta(Filtro, IntToStr(Pagina));
    RetornoConsulta.Active := True;

    RetornoConsulta.GetFieldNames(ListaCampos);

    RetornoConsulta.First;
    while not RetornoConsulta.EOF do begin
      CDSGrid.Append;
      for i := 0 to ListaCampos.Count - 1 do
      begin
        CDSGrid.FieldByName(ListaCampos[i]).Value := RetornoConsulta.FieldByName(ListaCampos[i]).Value;
      end;
      CDSGrid.Post;
      RetornoConsulta.Next;
    end;
  end;
end;

procedure TFContabilHistorico.BotaoSalvarClick(Sender: TObject);
begin
  inherited;
  BotaoConsultarClick(Sender);
end;

procedure TFContabilHistorico.FormCreate(Sender: TObject);
begin
  ClasseObjetoGridVO := TContabilHistoricoVO;
  ObjetoController := TContabilHistoricoController.Create;

  inherited;
end;
{$ENDREGION}

{$REGION 'Controles CRUD'}
function TFContabilHistorico.DoInserir: Boolean;
begin
  Result := inherited DoInserir;

  if Result then
  begin
    EditDescricao.SetFocus;
  end;
end;

function TFContabilHistorico.DoEditar: Boolean;
begin
  Result := inherited DoEditar;

  if Result then
  begin
    EditDescricao.SetFocus;
  end;
end;

function TFContabilHistorico.DoExcluir: Boolean;
begin
  if inherited DoExcluir then
  begin
    try
      Result := TContabilHistoricoController.Exclui(IdRegistroSelecionado);
    except
      Result := False;
    end;
  end
  else
  begin
    Result := False;
  end;

  if Result then
    BotaoConsultar.Click;
end;

function TFContabilHistorico.DoSalvar: Boolean;
begin
  Result := inherited DoSalvar;

  if Result then
  begin
    try
      if not Assigned(ObjetoVO) then
        ObjetoVO := TContabilHistoricoVO.Create;

      TContabilHistoricoVO(ObjetoVO).IdEmpresa := Sessao.Empresa.Id;
      TContabilHistoricoVO(ObjetoVO).Descricao := EditDescricao.Text;
      TContabilHistoricoVO(ObjetoVO).Historico := MemoHistorico.Text;
      TContabilHistoricoVO(ObjetoVO).PedeComplemento := Copy(ComboBoxPedeComplemento.Text, 1, 1);

      if StatusTela = stInserindo then
      begin
        TContabilHistoricoController.Insere(TContabilHistoricoVO(ObjetoVO));
      end
      else if StatusTela = stEditando then
      begin
        if TContabilHistoricoVO(ObjetoVO).ToJSONString <> StringObjetoOld then
        begin
          TContabilHistoricoController.Altera(TContabilHistoricoVO(ObjetoVO));
        end
        else
          Application.MessageBox('Nenhum dado foi alterado.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
      end;
    except
      Result := False;
    end;
  end;
end;
{$ENDREGION}

{$REGION 'Controle de Grid'}
procedure TFContabilHistorico.GridParaEdits;
var
  IdCabecalho: String;
begin
  inherited;

  if not CDSGrid.IsEmpty then
  begin
    IdCabecalho := IntToStr(IdRegistroSelecionado);
    ObjetoVO := TContabilHistoricoController.ConsultaObjeto('ID=' + IdCabecalho);
  end;

  if Assigned(ObjetoVO) then
  begin
    EditDescricao.Text := TContabilHistoricoVO(ObjetoVO).Descricao;
    MemoHistorico.Text := TContabilHistoricoVO(ObjetoVO).Historico;
    ComboBoxPedeComplemento.ItemIndex := AnsiIndexStr(TContabilHistoricoVO(ObjetoVO).PedeComplemento, ['S', 'N']);

    // Serializa o objeto para consultar posteriormente se houve altera��es
    FormatSettings.DecimalSeparator := '.';
    StringObjetoOld := ObjetoVO.ToJSONString;
    FormatSettings.DecimalSeparator := ',';
  end;
end;
{$ENDREGION}

end.

