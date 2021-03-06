{ *******************************************************************************
Title: T2Ti ERP
Description: Janela para selecionar o cheque para pagamento

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

@author Albert Eije (alberteije@gmail.com)
@version 2.0
******************************************************************************* }
unit USelecionaCheque;

{$MODE Delphi}

interface

uses
  BrookHTTPClient, BrookFCLHTTPClientBroker, BrookHTTPUtils, BrookUtils, FPJson, ZDataset,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UTelaCadastro, Menus, StdCtrls, ExtCtrls, Buttons, Grids, DBGrids,
  ComCtrls, LabeledCtrls, rxdbgrid, rxtoolbar, DBCtrls, StrUtils,
  Math, Constantes, CheckLst, ActnList, ToolWin, ShellApi, db, BufDataset, Biblioteca,
  ULookup, VO, PessoaVO, ContaCaixaVO;

type

  { TFSelecionaCheque }

  TFSelecionaCheque = class(TForm)
    PanelCabecalho: TPanel;
    Bevel1: TBevel;
    Image1: TImage;
    Label2: TLabel;
    ActionToolBarPrincipal: TToolPanel;
    ActionManagerLocal: TActionList;
    ActionCancelar: TAction;
    PageControlItens: TPageControl;
    tsDados: TTabSheet;
    PanelDados: TPanel;
    EditBomPara: TLabeledDateEdit;
    EditValorCheque: TLabeledCalcEdit;
    MemoHistorico: TLabeledMemo;
    Bevel2: TBevel;
    ActionConfirmar: TAction;
    EditIdPessoa: TLabeledCalcEdit;
    EditPessoa: TLabeledEdit;
    EditCodigoBanco: TLabeledEdit;
    EditCodigoAgencia: TLabeledEdit;
    EditNumeroConta: TLabeledEdit;
    EditDataEmissao: TLabeledDateEdit;
    EditNumeroCheque: TLabeledCalcEdit;
    EditCpfCnpj: TLabeledEdit;
    EditIdContaCaixa: TLabeledCalcEdit;
    EditContaCaixa: TLabeledEdit;
    procedure ActionCancelarExecute(Sender: TObject);
    procedure EditIdContaCaixaKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditIdPessoaKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure ActionConfirmarExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Confirmou: Boolean;
  end;

var
  FSelecionaCheque: TFSelecionaCheque;
  PessoaVO: TPessoaVO;
  ContaCaixaVO: TContaCaixaVO;

implementation

uses
  PessoaController, ContaCaixaController;
{$R *.lfm}

{$REGION 'Infra'}
procedure TFSelecionaCheque.FormCreate(Sender: TObject);
begin
  PessoaVO := TPessoaVO.Create;
end;

procedure TFSelecionaCheque.FormShow(Sender: TObject);
begin
  Confirmou := False;
  EditIdPessoa.SetFocus;
end;
{$ENDREGION}

{$REGION 'Campos Transientes'}
procedure TFSelecionaCheque.EditIdContaCaixaKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = VK_F1 then
  begin
    if EditIdContaCaixa.Value <> 0 then
    begin
      ContaCaixaVO := TContaCaixaController.ConsultaObjeto('ID='+QuotedStr(EditIdContaCaixa.Text));

      if Assigned(ContaCaixaVO) then
      begin
        EditContaCaixa.Clear;
        EditContaCaixa.Text := ContaCaixaVO.Nome;
      end
    end;
  end;
end;

procedure TFSelecionaCheque.EditIdPessoaKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = VK_F1 then
  begin
    if EditIdPessoa.Value <> 0 then
    begin
      PessoaVO := TPessoaController.ConsultaObjeto('ID='+QuotedStr(EditIdPessoa.Text));

      if Assigned(PessoaVO) then
      begin
        EditPessoa.Clear;
        EditPessoa.Text := PessoaVO.Nome;
        if PessoaVO.Tipo = 'F' then
          EditCpfCnpj.Text := PessoaVO.PessoaFisicaVO.Cpf
        else
          EditCpfCnpj.Text := PessoaVO.PessoaJuridicaVO.Cnpj;
      end;
    end;
  end;
end;
{$ENDREGION}

{$REGION 'Actions'}
procedure TFSelecionaCheque.ActionCancelarExecute(Sender: TObject);
begin
  Close;
  PessoaVO := Nil;
end;

procedure TFSelecionaCheque.ActionConfirmarExecute(Sender: TObject);
begin
  if Trim(RetiraMascara(EditBomPara.Text)) = '' then
  begin
    Application.MessageBox('� necess�rio informar a data do cheque.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
    EditBomPara.SetFocus;
    Exit;
  end;
  if EditValorCheque.Value <= 0 then
  begin
    Application.MessageBox('� necess�rio informar o valor do cheque.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
    EditValorCheque.SetFocus;
    Exit;
  end;
  if EditNumeroCheque.AsInteger <= 0 then
  begin
    Application.MessageBox('� necess�rio informar o n�mero do cheque.', 'Mensagem do Sistema', MB_OK + MB_ICONINFORMATION);
    EditNumeroCheque.SetFocus;
    Exit;
  end;
  Confirmou := True;
  Close;
end;
{$ENDREGION}

end.

